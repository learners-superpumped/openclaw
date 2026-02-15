import { HttpService } from "@nestjs/axios";
import { Inject, Injectable } from "@nestjs/common";
import { ConfigService } from "@nestjs/config";
import { firstValueFrom } from "rxjs";

interface CreateKeyResponse {
  key: string;
  data: {
    hash: string;
    name: string;
    limit: number;
    limit_remaining: number;
    limit_reset: string;
  };
}

@Injectable()
export class OpenRouterService {
  private readonly managementKey: string;

  constructor(
    @Inject(HttpService) private httpService: HttpService,
    @Inject(ConfigService) configService: ConfigService,
  ) {
    this.managementKey = configService.getOrThrow<string>("OPENROUTER_MANAGEMENT_KEY");
  }

  async createKey(
    name: string,
  ): Promise<{ key: string; hash: string; limit: number; limitRemaining: number }> {
    const { data } = await firstValueFrom(
      this.httpService.post<CreateKeyResponse>(
        "https://openrouter.ai/api/v1/keys",
        { name, limit: 5, limit_reset: "weekly" },
        { headers: { Authorization: `Bearer ${this.managementKey}` } },
      ),
    );

    return {
      key: data.key,
      hash: data.data.hash,
      limit: data.data.limit,
      limitRemaining: data.data.limit_remaining,
    };
  }
}
