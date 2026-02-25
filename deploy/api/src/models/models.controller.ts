import { Controller, Get, Inject } from "@nestjs/common";
import { ApiBearerAuth, ApiOperation, ApiTags } from "@nestjs/swagger";
import { OpenRouterService } from "../openrouter/openrouter.service.js";

@ApiTags("Models")
@ApiBearerAuth()
@Controller("models")
export class ModelsController {
  constructor(@Inject(OpenRouterService) private openRouterService: OpenRouterService) {}

  @Get()
  @ApiOperation({ summary: "OpenRouter 모델 목록 조회" })
  async listModels() {
    const models = await this.openRouterService.listModels();
    return { models };
  }
}
