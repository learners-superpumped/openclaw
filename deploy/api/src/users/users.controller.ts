import { Controller, Get, Inject, Request } from "@nestjs/common";
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
}
