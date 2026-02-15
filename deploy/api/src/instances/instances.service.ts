import { ForbiddenException, Inject, Injectable, NotFoundException } from "@nestjs/common";
import { randomUUID } from "node:crypto";
import { ManagerService } from "../manager/manager.service.js";
import { OpenRouterService } from "../openrouter/openrouter.service.js";
import { PrismaService } from "../prisma/prisma.service.js";
import { RevenueCatService } from "../revenuecat/revenuecat.service.js";
import { CreateInstanceDto } from "./dto/create-instance.dto.js";

@Injectable()
export class InstancesService {
  constructor(
    @Inject(PrismaService) private prisma: PrismaService,
    @Inject(ManagerService) private managerService: ManagerService,
    @Inject(OpenRouterService) private openRouterService: OpenRouterService,
    @Inject(RevenueCatService) private revenueCatService: RevenueCatService,
  ) {}

  async create(userId: string, dto: CreateInstanceDto) {
    const isActive = await this.revenueCatService.isEntitlementActive(userId);
    if (!isActive) {
      throw new ForbiddenException("Active subscription required");
    }

    const instanceId = `u${randomUUID().slice(0, 8)}`;
    const keyName = `openclaw-${instanceId}`;

    const openRouterKey = await this.openRouterService.createKey(keyName);

    const managerResult = await this.managerService.createInstance(instanceId, {
      OPENROUTER_API_KEY: openRouterKey.key,
    });

    const instance = await this.prisma.instance.create({
      data: {
        instanceId,
        userId,
        displayName: dto.displayName,
        openRouterKey: {
          create: {
            key: openRouterKey.key,
            keyHash: openRouterKey.hash,
            name: keyName,
            limit: openRouterKey.limit,
            limitReset: "weekly",
          },
        },
      },
    });

    return { ...instance, manager: managerResult };
  }

  async findAllByUser(userId: string) {
    const instances = await this.prisma.instance.findMany({
      where: { userId },
      orderBy: { createdAt: "desc" },
    });

    const enriched = await Promise.all(
      instances.map(async (inst) => {
        try {
          const status = await this.managerService.getInstance(inst.instanceId);
          return { ...inst, manager: status };
        } catch {
          return { ...inst, manager: null };
        }
      }),
    );

    return enriched;
  }

  async findOne(userId: string, instanceId: string) {
    const instance = await this.verifyOwnership(userId, instanceId);
    const managerStatus = await this.managerService.getInstance(instanceId);
    return { ...instance, manager: managerStatus };
  }

  async remove(userId: string, instanceId: string) {
    await this.verifyOwnership(userId, instanceId);

    const openRouterKey = await this.prisma.openRouterKey.findUnique({
      where: { instanceId },
    });
    if (openRouterKey) {
      await this.openRouterService.deleteKey(openRouterKey.keyHash);
    }

    const managerResult = await this.managerService.deleteInstance(instanceId);
    await this.prisma.instance.delete({ where: { instanceId } });
    return managerResult;
  }

  async requestQr(userId: string, instanceId: string) {
    await this.verifyOwnership(userId, instanceId);
    return this.managerService.requestQr(instanceId);
  }

  async waitForQr(userId: string, instanceId: string) {
    await this.verifyOwnership(userId, instanceId);
    return this.managerService.waitForQr(instanceId);
  }

  async getWhatsappStatus(userId: string, instanceId: string) {
    await this.verifyOwnership(userId, instanceId);
    return this.managerService.getWhatsappStatus(instanceId);
  }

  async setupTelegram(userId: string, instanceId: string, botToken: string, accountId?: string) {
    await this.verifyOwnership(userId, instanceId);
    return this.managerService.setupTelegram(instanceId, botToken, accountId);
  }

  async getTelegramStatus(userId: string, instanceId: string, probe?: boolean) {
    await this.verifyOwnership(userId, instanceId);
    return this.managerService.getTelegramStatus(instanceId, probe);
  }

  async logoutTelegram(userId: string, instanceId: string, accountId?: string) {
    await this.verifyOwnership(userId, instanceId);
    return this.managerService.logoutTelegram(instanceId, accountId);
  }

  async listPairing(userId: string, instanceId: string, channel: string) {
    await this.verifyOwnership(userId, instanceId);
    return this.managerService.listPairing(instanceId, channel);
  }

  async approvePairing(
    userId: string,
    instanceId: string,
    channel: string,
    code: string,
    notify?: boolean,
  ) {
    await this.verifyOwnership(userId, instanceId);
    return this.managerService.approvePairing(instanceId, channel, code, notify);
  }

  async rpc(userId: string, instanceId: string, body: unknown) {
    await this.verifyOwnership(userId, instanceId);
    return this.managerService.rpc(instanceId, body);
  }

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
