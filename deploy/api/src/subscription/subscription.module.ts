import { Module } from "@nestjs/common";
import { InstancesModule } from "../instances/instances.module.js";
import { RevenueCatModule } from "../revenuecat/revenuecat.module.js";
import { SubscriptionService } from "./subscription.service.js";

@Module({
  imports: [RevenueCatModule, InstancesModule],
  providers: [SubscriptionService],
})
export class SubscriptionModule {}
