import { Inject, Injectable, OnModuleDestroy } from "@nestjs/common";
import { ConfigService } from "@nestjs/config";
import { PrismaPg } from "@prisma/adapter-pg";
import { PrismaClient } from "../generated/prisma/client.js";

@Injectable()
export class PrismaService implements OnModuleDestroy {
  private client: InstanceType<typeof PrismaClient>;

  constructor(@Inject(ConfigService) configService: ConfigService) {
    const connectionString = configService.getOrThrow<string>("DATABASE_URL");
    const adapter = new PrismaPg({ connectionString });
    this.client = new PrismaClient({ adapter });
  }

  get user() {
    return this.client.user;
  }

  get instance() {
    return this.client.instance;
  }

  get openRouterKey() {
    return this.client.openRouterKey;
  }

  async onModuleDestroy() {
    await this.client.$disconnect();
  }
}
