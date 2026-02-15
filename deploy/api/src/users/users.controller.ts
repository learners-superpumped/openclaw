import {
  Body,
  Controller,
  Delete,
  Get,
  HttpCode,
  HttpStatus,
  Inject,
  Patch,
  Request,
} from "@nestjs/common";
import { ApiBearerAuth, ApiOperation, ApiTags } from "@nestjs/swagger";
import { ValidatePromoDto } from "../promo/dto/validate-promo.dto.js";
import { UsersService } from "./users.service.js";

@ApiTags("Users")
@ApiBearerAuth()
@Controller("users")
export class UsersController {
  constructor(@Inject(UsersService) private usersService: UsersService) {}

  @Get("me")
  @ApiOperation({ summary: "내 프로필 조회" })
  getMe(@Request() req: any) {
    return this.usersService.findById(req.user.sub);
  }

  @Patch("me/promo")
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiOperation({ summary: "프로모션 코드 활성화" })
  async activatePromo(@Request() req: any, @Body() dto: ValidatePromoDto) {
    await this.usersService.activatePromo(req.user.sub, dto.code);
  }

  @Delete("me")
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiOperation({ summary: "회원 탈퇴" })
  async deleteMe(@Request() req: any) {
    await this.usersService.deleteAccount(req.user.sub);
  }
}
