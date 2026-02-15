import { Inject, Injectable, NotFoundException } from "@nestjs/common";
import { InstancesService } from "../instances/instances.service.js";
import { PrismaService } from "../prisma/prisma.service.js";

@Injectable()
export class UsersService {
  constructor(
    @Inject(PrismaService) private prisma: PrismaService,
    @Inject(InstancesService) private instancesService: InstancesService,
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

    await this.prisma.user.delete({ where: { id: userId } });
  }
}
