import type { Cache } from "cache-manager";
import { HttpService } from "@nestjs/axios";
import { CACHE_MANAGER } from "@nestjs/cache-manager";
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

export interface OpenRouterModel {
  id: string;
  name: string;
  context_length: number | null;
  pricing: {
    prompt: string;
    completion: string;
  } | null;
}

const MODELS_CACHE_KEY = "openrouter:models";
const MODELS_CACHE_TTL_MS = 10 * 60 * 1000; // 10 minutes

@Injectable()
export class OpenRouterService {
  private readonly managementKey: string;

  constructor(
    @Inject(HttpService) private httpService: HttpService,
    @Inject(ConfigService) configService: ConfigService,
    @Inject(CACHE_MANAGER) private cacheManager: Cache,
  ) {
    this.managementKey = configService.getOrThrow<string>("OPENROUTER_MANAGEMENT_KEY");
  }

  async listModels(): Promise<OpenRouterModel[]> {
    const cached = await this.cacheManager.get<OpenRouterModel[]>(MODELS_CACHE_KEY);
    if (cached) {
      return cached;
    }

    const { data } = await firstValueFrom(
      this.httpService.get<{ data: OpenRouterModel[] }>("https://openrouter.ai/api/v1/models"),
    );

    const models = (data.data ?? []).map((m) => ({
      id: m.id,
      name: m.name,
      context_length: m.context_length,
      pricing: m.pricing,
    }));

    await this.cacheManager.set(MODELS_CACHE_KEY, models, MODELS_CACHE_TTL_MS);
    return models;
  }

  async deleteKey(hash: string): Promise<void> {
    try {
      await firstValueFrom(
        this.httpService.delete(`https://openrouter.ai/api/v1/keys/${hash}`, {
          headers: { Authorization: `Bearer ${this.managementKey}` },
        }),
      );
    } catch (error: any) {
      if (error?.response?.status === 404) {
        return;
      }
      throw error;
    }
  }

  async getKeyUsage(
    hash: string,
  ): Promise<{ limit: number; limitRemaining: number; limitReset: string }> {
    const { data } = await firstValueFrom(
      this.httpService.get<{
        data: { limit: number; limit_remaining: number; limit_reset: string };
      }>(`https://openrouter.ai/api/v1/keys/${hash}`, {
        headers: { Authorization: `Bearer ${this.managementKey}` },
      }),
    );
    return {
      limit: data.data.limit,
      limitRemaining: data.data.limit_remaining,
      limitReset: data.data.limit_reset,
    };
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
