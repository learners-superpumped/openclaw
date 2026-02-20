import type { Cache } from "cache-manager";
import { HttpService } from "@nestjs/axios";
import { CACHE_MANAGER } from "@nestjs/cache-manager";
import { Inject, Injectable } from "@nestjs/common";
import { ConfigService } from "@nestjs/config";
import { firstValueFrom } from "rxjs";
import { callConvexAction } from "./convex-ws-client.js";

const DEFAULT_BASE_URL = "https://wry-manatee-359.convex.site/api/v1";
const DEFAULT_SYNC_URL = "wss://wry-manatee-359.convex.cloud/api/1.31.7/sync";
const TTL_SHORT = 60_000; // 60s for list/search
const TTL_LONG = 300_000; // 5min for detail/versions

@Injectable()
export class ClawHubApiService {
  private readonly baseUrl: string;
  private readonly syncUrl: string;

  constructor(
    @Inject(HttpService) private httpService: HttpService,
    @Inject(ConfigService) configService: ConfigService,
    @Inject(CACHE_MANAGER) private cache: Cache,
  ) {
    this.baseUrl = configService.get<string>("CLAWHUB_API_URL") ?? DEFAULT_BASE_URL;
    this.syncUrl = configService.get<string>("CONVEX_SYNC_URL") ?? DEFAULT_SYNC_URL;
  }

  private async cached<T>(key: string, ttl: number, fetcher: () => Promise<T>): Promise<T> {
    const hit = await this.cache.get<T>(key);
    if (hit !== undefined && hit !== null) {
      return hit;
    }
    const result = await fetcher();
    await this.cache.set(key, result, ttl);
    return result;
  }

  private cacheKey(prefix: string, params?: Record<string, unknown>): string {
    if (!params) {
      return `clawhub:${prefix}`;
    }
    const sorted = Object.keys(params)
      .toSorted()
      .filter((k) => params[k] !== undefined && params[k] !== null)
      .map((k) => `${k}=${params[k]}`)
      .join("&");
    return `clawhub:${prefix}:${sorted}`;
  }

  async listSkills(params: { sort?: string; limit?: number; cursor?: string; q?: string }) {
    const key = this.cacheKey("skills", params as Record<string, unknown>);
    return this.cached(key, TTL_SHORT, async () => {
      const { data } = await firstValueFrom(
        this.httpService.get(`${this.baseUrl}/skills`, { params }),
      );
      return data;
    });
  }

  async searchSkillsWs(q: string, limit = 20) {
    const key = this.cacheKey("search-ws", { q, limit });
    return this.cached(key, TTL_SHORT, async () => {
      const result = await callConvexAction<any[]>({
        syncUrl: this.syncUrl,
        udfPath: "search:searchSkills",
        args: { query: q, limit },
      });

      return {
        items: (result ?? []).map((r: any) => ({
          slug: r.skill?.slug,
          displayName: r.skill?.displayName,
          summary: r.skill?.summary,
          stats: r.skill?.stats,
          owner: r.owner,
          score: r.score,
        })),
        nextCursor: null,
      };
    });
  }

  async getSkill(slug: string) {
    const key = this.cacheKey(`skill:${slug}`);
    return this.cached(key, TTL_LONG, async () => {
      const { data } = await firstValueFrom(this.httpService.get(`${this.baseUrl}/skills/${slug}`));
      return data;
    });
  }

  async getSkillVersions(slug: string) {
    const key = this.cacheKey(`versions:${slug}`);
    return this.cached(key, TTL_LONG, async () => {
      const { data } = await firstValueFrom(
        this.httpService.get(`${this.baseUrl}/skills/${slug}/versions`),
      );
      return data;
    });
  }
}
