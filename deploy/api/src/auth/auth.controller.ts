import { Body, Controller, Inject, Post } from "@nestjs/common";
import { ApiOperation, ApiTags } from "@nestjs/swagger";
import { AuthService } from "./auth.service.js";
import { AppleAuthDto } from "./dto/apple-auth.dto.js";
import { GoogleAuthDto } from "./dto/google-auth.dto.js";
import { LoginDto } from "./dto/login.dto.js";
import { RefreshDto } from "./dto/refresh.dto.js";
import { SignupDto } from "./dto/signup.dto.js";
import { Public } from "./public.decorator.js";

@ApiTags("Auth")
@Controller("auth")
export class AuthController {
  constructor(@Inject(AuthService) private authService: AuthService) {}

  @Public()
  @Post("signup")
  @ApiOperation({ summary: "회원가입" })
  signup(@Body() dto: SignupDto) {
    return this.authService.signup(dto);
  }

  @Public()
  @Post("login")
  @ApiOperation({ summary: "로그인" })
  login(@Body() dto: LoginDto) {
    return this.authService.login(dto);
  }

  @Public()
  @Post("refresh")
  @ApiOperation({ summary: "토큰 갱신" })
  refresh(@Body() dto: RefreshDto) {
    return this.authService.refresh(dto.refreshToken);
  }

  @Public()
  @Post("google")
  @ApiOperation({ summary: "Google 소셜 로그인" })
  googleLogin(@Body() dto: GoogleAuthDto) {
    return this.authService.googleLogin(dto);
  }

  @Public()
  @Post("apple")
  @ApiOperation({ summary: "Apple 소셜 로그인" })
  appleLogin(@Body() dto: AppleAuthDto) {
    return this.authService.appleLogin(dto);
  }
}
