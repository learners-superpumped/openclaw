import { Module } from "@nestjs/common";
import { InstancesModule } from "../instances/instances.module.js";
import { UsersController } from "./users.controller.js";
import { UsersService } from "./users.service.js";

@Module({
  imports: [InstancesModule],
  controllers: [UsersController],
  providers: [UsersService],
})
export class UsersModule {}
