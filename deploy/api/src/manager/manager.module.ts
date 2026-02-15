import { HttpModule } from "@nestjs/axios";
import { Module } from "@nestjs/common";
import { ManagerService } from "./manager.service.js";

@Module({
  imports: [HttpModule],
  providers: [ManagerService],
  exports: [ManagerService],
})
export class ManagerModule {}
