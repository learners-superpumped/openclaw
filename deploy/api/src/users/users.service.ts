import { BadRequestException, Inject, Injectable, NotFoundException } from "@nestjs/common";
import { InstancesService } from "../instances/instances.service.js";
import { OpenRouterService } from "../openrouter/openrouter.service.js";
import { PrismaService } from "../prisma/prisma.service.js";
import { PromoService } from "../promo/promo.service.js";

@Injectable()
export class UsersService {
  constructor(
    @Inject(PrismaService) private prisma: PrismaService,
    @Inject(InstancesService) private instancesService: InstancesService,
    @Inject(OpenRouterService) private openRouterService: OpenRouterService,
    @Inject(PromoService) private promoService: PromoService,
  ) {}

  async findById(id: string) {
    const user = await this.prisma.user.findUnique({
      where: { id },
      select: {
        id: true,
        email: true,
        name: true,
        provider: true,
        avatarUrl: true,
        createdAt: true,
        updatedAt: true,
      },
    });
    if (!user) {
      throw new NotFoundException("User not found");
    }
    return user;
  }

  async deleteAccount(userId: string) {
    const instances = await this.prisma.instance.findMany({
      where: { userId },
    });

    for (const instance of instances) {
      await this.instancesService.remove(userId, instance.instanceId);
    }

    const openRouterKey = await this.prisma.openRouterKey.findUnique({
      where: { userId },
    });
    if (openRouterKey) {
      await this.openRouterService.deleteKey(openRouterKey.keyHash);
    }

    await this.prisma.user.delete({ where: { id: userId } });
  }

  async activatePromo(userId: string, code: string) {
    if (!this.promoService.isValidCode(code)) {
      throw new BadRequestException("Invalid promo code");
    }
    await this.prisma.user.update({
      where: { id: userId },
      data: { isPromo: true },
    });
  }
}
