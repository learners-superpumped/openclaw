import { ConflictException, Inject, Injectable, UnauthorizedException } from "@nestjs/common";
import { ConfigService } from "@nestjs/config";
import { JwtService } from "@nestjs/jwt";
import { verifyIdToken as verifyAppleToken } from "apple-signin-auth";
import { hash, compare } from "bcrypt";
import { OAuth2Client } from "google-auth-library";
import { PrismaService } from "../prisma/prisma.service.js";
import { AppleAuthDto } from "./dto/apple-auth.dto.js";
import { GoogleAuthDto } from "./dto/google-auth.dto.js";
import { LoginDto } from "./dto/login.dto.js";
import { SignupDto } from "./dto/signup.dto.js";

const SALT_ROUNDS = 10;
const ACCESS_TOKEN_EXPIRES = "15m";
const REFRESH_TOKEN_EXPIRES = "7d";

@Injectable()
export class AuthService {
  constructor(
    @Inject(PrismaService) private prisma: PrismaService,
    @Inject(JwtService) private jwtService: JwtService,
    @Inject(ConfigService) private configService: ConfigService,
  ) {}

  async signup(dto: SignupDto) {
    const existing = await this.prisma.user.findUnique({
      where: { email: dto.email },
    });
    if (existing) {
      throw new ConflictException("Email already registered");
    }

    const passwordHash = await hash(dto.password, SALT_ROUNDS);
    const user = await this.prisma.user.create({
      data: {
        email: dto.email,
        passwordHash,
        name: dto.name,
      },
    });

    return this.generateTokens(user.id, user.email);
  }

  async login(dto: LoginDto) {
    const user = await this.prisma.user.findUnique({
      where: { email: dto.email },
    });
    if (!user || !user.passwordHash) {
      throw new UnauthorizedException("Invalid credentials");
    }

    const valid = await compare(dto.password, user.passwordHash);
    if (!valid) {
      throw new UnauthorizedException("Invalid credentials");
    }

    return this.generateTokens(user.id, user.email);
  }

  async googleLogin(dto: GoogleAuthDto) {
    const clientId = this.configService.getOrThrow<string>("GOOGLE_CLIENT_ID");
    const client = new OAuth2Client(clientId);
    const ticket = await client.verifyIdToken({
      idToken: dto.idToken,
      audience: clientId,
    });
    const payload = ticket.getPayload();
    if (!payload || !payload.email) {
      throw new UnauthorizedException("Invalid Google ID token");
    }

    const user = await this.prisma.user.upsert({
      where: {
        provider_providerId: { provider: "google", providerId: payload.sub },
      },
      update: {
        name: payload.name ?? undefined,
        avatarUrl: payload.picture ?? undefined,
      },
      create: {
        email: payload.email,
        provider: "google",
        providerId: payload.sub,
        name: payload.name,
        avatarUrl: payload.picture,
      },
    });

    return this.generateTokens(user.id, user.email);
  }

  async appleLogin(dto: AppleAuthDto) {
    const clientId = this.configService.getOrThrow<string>("APPLE_CLIENT_ID");
    const payload = await verifyAppleToken(dto.identityToken, {
      audience: clientId,
    });
    if (!payload.sub || !payload.email) {
      throw new UnauthorizedException("Invalid Apple identity token");
    }

    const name = [dto.givenName, dto.familyName].filter(Boolean).join(" ") || undefined;

    const user = await this.prisma.user.upsert({
      where: {
        provider_providerId: { provider: "apple", providerId: payload.sub },
      },
      update: {
        name: name ?? undefined,
      },
      create: {
        email: payload.email,
        provider: "apple",
        providerId: payload.sub,
        name,
      },
    });

    return this.generateTokens(user.id, user.email);
  }

  async refresh(refreshToken: string) {
    try {
      const payload = await this.jwtService.verifyAsync(refreshToken);
      if (payload.type !== "refresh") {
        throw new UnauthorizedException("Invalid token type");
      }

      const user = await this.prisma.user.findUnique({
        where: { id: payload.sub },
      });
      if (!user) {
        throw new UnauthorizedException("User not found");
      }

      return this.generateTokens(user.id, user.email);
    } catch (error) {
      if (error instanceof UnauthorizedException) {
        throw error;
      }
      throw new UnauthorizedException("Invalid refresh token");
    }
  }

  private async generateTokens(userId: string, email: string) {
    const [accessToken, refreshToken] = await Promise.all([
      this.jwtService.signAsync({ sub: userId, email }, { expiresIn: ACCESS_TOKEN_EXPIRES }),
      this.jwtService.signAsync(
        { sub: userId, type: "refresh" },
        { expiresIn: REFRESH_TOKEN_EXPIRES },
      ),
    ]);

    return { accessToken, refreshToken };
  }
}
