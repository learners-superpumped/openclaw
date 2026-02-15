import { HttpModule } from "@nestjs/axios";
import { Module } from "@nestjs/common";
import { OpenRouterService } from "./openrouter.service.js";

@Module({
  imports: [HttpModule],
  providers: [OpenRouterService],
  exports: [OpenRouterService],
})
export class OpenRouterModule {}
