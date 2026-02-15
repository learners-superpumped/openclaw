import { Module } from "@nestjs/common";
import { ManagerModule } from "../manager/manager.module.js";
import { OpenRouterModule } from "../openrouter/openrouter.module.js";
import { RevenueCatModule } from "../revenuecat/revenuecat.module.js";
import { InstancesController } from "./instances.controller.js";
import { InstancesService } from "./instances.service.js";

@Module({
  imports: [ManagerModule, OpenRouterModule, RevenueCatModule],
  controllers: [InstancesController],
  providers: [InstancesService],
  exports: [InstancesService],
})
export class InstancesModule {}
