import { CacheModule } from "@nestjs/cache-manager";
import { Module } from "@nestjs/common";
import { ConfigModule } from "@nestjs/config";
import { APP_GUARD } from "@nestjs/core";
import { JwtModule } from "@nestjs/jwt";
import { ScheduleModule } from "@nestjs/schedule";
import { AuthGuard } from "./auth/auth.guard.js";
import { AuthModule } from "./auth/auth.module.js";
import { ClawHubModule } from "./clawhub/clawhub.module.js";
import { HealthController } from "./health.controller.js";
import { InstancesModule } from "./instances/instances.module.js";
import { LegalModule } from "./legal/legal.module.js";
import { PrismaModule } from "./prisma/prisma.module.js";
import { PromoModule } from "./promo/promo.module.js";
import { SubscriptionModule } from "./subscription/subscription.module.js";
import { UsersModule } from "./users/users.module.js";

@Module({
  imports: [
    CacheModule.register({ isGlobal: true, ttl: 60_000 }),
    ConfigModule.forRoot({ isGlobal: true }),
    JwtModule.registerAsync({
      global: true,
      useFactory: () => ({
        secret: process.env.JWT_SECRET,
        signOptions: { expiresIn: "15m" },
      }),
    }),
    ScheduleModule.forRoot(),
    PrismaModule,
    AuthModule,
    UsersModule,
    InstancesModule,
    ClawHubModule,
    SubscriptionModule,
    LegalModule,
    PromoModule,
  ],
  controllers: [HealthController],
  providers: [{ provide: APP_GUARD, useClass: AuthGuard }],
})
export class AppModule {}
