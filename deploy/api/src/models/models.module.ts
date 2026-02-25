import { Module } from "@nestjs/common";
import { OpenRouterModule } from "../openrouter/openrouter.module.js";
import { ModelsController } from "./models.controller.js";

@Module({
  imports: [OpenRouterModule],
  controllers: [ModelsController],
})
export class ModelsModule {}
