import { Inject, Injectable, Logger } from "@nestjs/common";
import { Cron, CronExpression } from "@nestjs/schedule";
import { InstancesService } from "../instances/instances.service.js";
import { PrismaService } from "../prisma/prisma.service.js";
import { RevenueCatService } from "../revenuecat/revenuecat.service.js";

@Injectable()
export class SubscriptionService {
  private readonly logger = new Logger(SubscriptionService.name);
  private isRunning = false;

  constructor(
    @Inject(PrismaService) private prisma: PrismaService,
    @Inject(RevenueCatService) private revenueCat: RevenueCatService,
    @Inject(InstancesService) private instancesService: InstancesService,
  ) {}

  @Cron(CronExpression.EVERY_10_MINUTES)
  async validateSubscriptions() {
    if (this.isRunning) {
      this.logger.warn("Previous subscription validation still running, skipping");
      return;
    }

    this.isRunning = true;
    this.logger.log("Starting subscription validation");

    let usersChecked = 0;
    let usersExpired = 0;
    let instancesRemoved = 0;

    try {
      const users = await this.prisma.instance.findMany({
        select: { userId: true },
        distinct: ["userId"],
      });

      for (const { userId } of users) {
        usersChecked++;

        let isActive: boolean;
        try {
          isActive = await this.revenueCat.isEntitlementActive(userId);
        } catch (error) {
          this.logger.warn(`Failed to check subscription for user ${userId}, skipping: ${error}`);
          continue;
        }

        if (isActive) {
          continue;
        }

        usersExpired++;
        const instances = await this.prisma.instance.findMany({
          where: { userId },
          select: { instanceId: true },
        });

        for (const { instanceId } of instances) {
          try {
            await this.instancesService.remove(userId, instanceId);
            instancesRemoved++;
            this.logger.log(`Removed instance ${instanceId} for expired user ${userId}`);
          } catch (error) {
            this.logger.error(
              `Failed to remove instance ${instanceId} for user ${userId}: ${error}`,
            );
          }
        }
      }
    } finally {
      this.isRunning = false;
    }

    this.logger.log(
      `Subscription validation complete: ${usersChecked} users checked, ${usersExpired} expired, ${instancesRemoved} instances removed`,
    );
  }
}
