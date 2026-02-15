import { Module } from "@nestjs/common";
import { InstancesModule } from "../instances/instances.module.js";
import { PromoModule } from "../promo/promo.module.js";
import { UsersController } from "./users.controller.js";
import { UsersService } from "./users.service.js";

@Module({
  imports: [InstancesModule, PromoModule],
  controllers: [UsersController],
  providers: [UsersService],
})
export class UsersModule {}
