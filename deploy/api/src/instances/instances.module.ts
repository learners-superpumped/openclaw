import { Module } from "@nestjs/common";
import { ManagerModule } from "../manager/manager.module.js";
import { InstancesController } from "./instances.controller.js";
import { InstancesService } from "./instances.service.js";

@Module({
  imports: [ManagerModule],
  controllers: [InstancesController],
  providers: [InstancesService],
})
export class InstancesModule {}
