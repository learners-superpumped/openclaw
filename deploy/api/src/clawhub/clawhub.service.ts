import {
  BadRequestException,
  ForbiddenException,
  Inject,
  Injectable,
  NotFoundException,
} from "@nestjs/common";
import { ManagerService } from "../manager/manager.service.js";
import { PrismaService } from "../prisma/prisma.service.js";
import { ClawHubApiService } from "./clawhub-api.service.js";

@Injectable()
export class ClawHubService {
  constructor(
    @Inject(ClawHubApiService) private clawHubApi: ClawHubApiService,
    @Inject(PrismaService) private prisma: PrismaService,
    @Inject(ManagerService) private managerService: ManagerService,
  ) {}

  // ── Proxy methods ──

  listSkills(params: { sort?: string; limit?: number; cursor?: string; q?: string }) {
    return this.clawHubApi.listSkills(params);
  }

  getSkill(slug: string) {
    return this.clawHubApi.getSkill(slug);
  }

  getSkillVersions(slug: string) {
    return this.clawHubApi.getSkillVersions(slug);
  }

  // ── Install / Uninstall ──

  async installSkill(userId: string, instanceId: string, slug: string, version?: string) {
    const instance = await this.verifyOwnership(userId, instanceId);

    // Validate slug exists on ClawHub
    const skillInfo = await this.clawHubApi.getSkill(slug);

    // Call Manager to install via clawhub CLI
    try {
      await this.managerService.hubInstallSkill(instanceId, slug, version);
    } catch (err: any) {
      throw new BadRequestException(`Skill install failed: ${err.message ?? err}`);
    }

    // Upsert DB record
    const resolvedVersion = version ?? skillInfo.latestVersion?.version ?? "latest";
    const record = await this.prisma.installedSkill.upsert({
      where: { instanceId_slug: { instanceId: instance.id, slug } },
      create: {
        instanceId: instance.id,
        slug,
        version: resolvedVersion,
        displayName: skillInfo.skill?.name ?? slug,
        summary: skillInfo.skill?.summary ?? null,
      },
      update: {
        version: resolvedVersion,
        displayName: skillInfo.skill?.name ?? slug,
        summary: skillInfo.skill?.summary ?? null,
      },
    });

    return record;
  }

  async uninstallSkill(userId: string, instanceId: string, slug: string) {
    const instance = await this.verifyOwnership(userId, instanceId);

    // Call Manager to uninstall via clawhub CLI
    try {
      await this.managerService.hubUninstallSkill(instanceId, slug);
    } catch (err: any) {
      throw new BadRequestException(`Skill uninstall failed: ${err.message ?? err}`);
    }

    // Delete DB record
    await this.prisma.installedSkill.deleteMany({
      where: { instanceId: instance.id, slug },
    });

    return { success: true };
  }

  // ── Query installed skills ──

  async getInstalledSkills(userId: string, instanceId: string) {
    const instance = await this.verifyOwnership(userId, instanceId);
    return this.prisma.installedSkill.findMany({
      where: { instanceId: instance.id },
      orderBy: { installedAt: "desc" },
    });
  }

  // ── Browse with install status enrichment ──

  async browseSkills(
    userId: string,
    instanceId: string,
    params: { sort?: string; limit?: number; cursor?: string; q?: string },
  ) {
    const instance = await this.verifyOwnership(userId, instanceId);

    const skillsPromise = params.q
      ? this.clawHubApi.searchSkillsWs(params.q, params.limit)
      : this.clawHubApi.listSkills(params);

    const [skills, installed] = await Promise.all([
      skillsPromise,
      this.prisma.installedSkill.findMany({
        where: { instanceId: instance.id },
        select: { slug: true, version: true },
      }),
    ]);

    const installedMap = new Map(installed.map((s) => [s.slug, s.version]));

    return {
      skills: (skills.items ?? []).map((s: any) => ({
        ...s,
        installed: installedMap.has(s.slug),
        installedVersion: installedMap.get(s.slug) ?? null,
      })),
      cursor: skills.nextCursor ?? null,
    };
  }

  async browseSkillDetail(userId: string, instanceId: string, slug: string) {
    const instance = await this.verifyOwnership(userId, instanceId);

    const [skillDetail, installedRecord] = await Promise.all([
      this.clawHubApi.getSkill(slug),
      this.prisma.installedSkill.findUnique({
        where: { instanceId_slug: { instanceId: instance.id, slug } },
      }),
    ]);

    return {
      ...skillDetail,
      installed: !!installedRecord,
      installedVersion: installedRecord?.version ?? null,
    };
  }

  // ── Ownership verification ──

  private async verifyOwnership(userId: string, instanceId: string) {
    const instance = await this.prisma.instance.findUnique({
      where: { instanceId },
    });
    if (!instance) {
      throw new NotFoundException("Instance not found");
    }
    if (instance.userId !== userId) {
      throw new ForbiddenException("Not your instance");
    }
    return instance;
  }
}
