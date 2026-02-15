import { Controller, Get } from "@nestjs/common";
import { ApiOperation, ApiTags } from "@nestjs/swagger";
import { Public } from "./auth/public.decorator.js";

@ApiTags("Health")
@Controller()
export class HealthController {
  @Public()
  @Get("health")
  @ApiOperation({ summary: "헬스체크" })
  health() {
    return { status: "ok" };
  }
}
