import { Controller, Delete, Get, HttpCode, HttpStatus, Inject, Request } from "@nestjs/common";
import { ApiBearerAuth, ApiOperation, ApiTags } from "@nestjs/swagger";
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

  @Delete("me")
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiOperation({ summary: "회원 탈퇴" })
  async deleteMe(@Request() req: any) {
    await this.usersService.deleteAccount(req.user.sub);
  }
}
