import { HttpModule } from "@nestjs/axios";
import { Module } from "@nestjs/common";
import { ManagerModule } from "../manager/manager.module.js";
import { ClawHubApiService } from "./clawhub-api.service.js";
import { ClawHubController } from "./clawhub.controller.js";
import { ClawHubService } from "./clawhub.service.js";

@Module({
  imports: [HttpModule, ManagerModule],
  controllers: [ClawHubController],
  providers: [ClawHubApiService, ClawHubService],
})
export class ClawHubModule {}
