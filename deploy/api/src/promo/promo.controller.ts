import { Body, Controller, Inject, Post } from "@nestjs/common";
import { ApiOperation, ApiTags } from "@nestjs/swagger";
import { Public } from "../auth/public.decorator.js";
import { ValidatePromoDto } from "./dto/validate-promo.dto.js";
import { PromoService } from "./promo.service.js";

@ApiTags("Promo")
@Controller("promo")
export class PromoController {
  constructor(@Inject(PromoService) private promoService: PromoService) {}

  @Public()
  @Post("validate")
  @ApiOperation({ summary: "프로모션 코드 검증" })
  validate(@Body() dto: ValidatePromoDto) {
    return { valid: this.promoService.isValidCode(dto.code) };
  }
}
