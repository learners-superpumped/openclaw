import { Module } from "@nestjs/common";
import { ManagerModule } from "../manager/manager.module.js";
import { OpenRouterModule } from "../openrouter/openrouter.module.js";
import { InstancesController } from "./instances.controller.js";
import { InstancesService } from "./instances.service.js";

@Module({
  imports: [ManagerModule, OpenRouterModule],
  controllers: [InstancesController],
  providers: [InstancesService],
})
export class InstancesModule {}
