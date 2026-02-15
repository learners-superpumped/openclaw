import { ForbiddenException, Inject, Injectable, NotFoundException } from "@nestjs/common";
import { randomUUID } from "node:crypto";
import { ManagerService } from "../manager/manager.service.js";
import { PrismaService } from "../prisma/prisma.service.js";
import { CreateInstanceDto } from "./dto/create-instance.dto.js";

@Injectable()
export class InstancesService {
  constructor(
    @Inject(PrismaService) private prisma: PrismaService,
    @Inject(ManagerService) private managerService: ManagerService,
  ) {}

  async create(userId: string, dto: CreateInstanceDto) {
    const instanceId = `u${randomUUID().slice(0, 8)}`;

    const managerResult = await this.managerService.createInstance(instanceId, dto.secrets);

    const instance = await this.prisma.instance.create({
      data: {
        instanceId,
        userId,
        displayName: dto.displayName,
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
