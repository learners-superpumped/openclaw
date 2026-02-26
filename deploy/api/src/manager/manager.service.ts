import { HttpService } from "@nestjs/axios";
import { HttpException, Inject, Injectable } from "@nestjs/common";
import { ConfigService } from "@nestjs/config";
import { isAxiosError } from "axios";
import { firstValueFrom } from "rxjs";

@Injectable()
export class ManagerService {
  private readonly baseUrl: string;
  private readonly apiKey: string;

  constructor(
    @Inject(HttpService) private httpService: HttpService,
    @Inject(ConfigService) configService: ConfigService,
  ) {
    this.baseUrl = configService.getOrThrow<string>("MANAGER_URL");
    this.apiKey = configService.getOrThrow<string>("MANAGER_API_KEY");
  }

  private get headers() {
    return { Authorization: `Bearer ${this.apiKey}` };
  }

  private rethrow(err: unknown): never {
    if (isAxiosError(err)) {
      const status = err.response?.status ?? 502;
      const body = err.response?.data ?? { error: err.message };
      throw new HttpException(body, status);
    }
    throw err;
  }

  async createInstance(
    instanceId: string,
    secrets: Record<string, string>,
    profile?: {
      user?: {
        name?: string;
        callName?: string;
        pronouns?: string;
        timezone?: string;
        notes?: string;
      };
      agent?: { name?: string; creature?: string; vibe?: string; emoji?: string; avatar?: string };
    },
  ) {
    const { data } = await firstValueFrom(
      this.httpService.post(
        `${this.baseUrl}/api/instances`,
        { userId: instanceId, secrets, ...(profile ? { profile } : {}) },
        { headers: this.headers },
      ),
    ).catch(this.rethrow);
    return data;
  }

  async getInstance(instanceId: string) {
    const { data } = await firstValueFrom(
      this.httpService.get(`${this.baseUrl}/api/instances/${instanceId}`, {
        headers: this.headers,
      }),
    ).catch(this.rethrow);
    return data;
  }

  async deleteInstance(instanceId: string) {
    const { data } = await firstValueFrom(
      this.httpService.delete(`${this.baseUrl}/api/instances/${instanceId}`, {
        headers: this.headers,
        params: { preservePvc: "false" },
      }),
    ).catch(this.rethrow);
    return data;
  }

  async requestQr(instanceId: string) {
    const { data } = await firstValueFrom(
      this.httpService.post(
        `${this.baseUrl}/api/instances/${instanceId}/whatsapp/qr`,
        {},
        { headers: this.headers },
      ),
    ).catch(this.rethrow);
    return data;
  }

  async waitForQr(instanceId: string) {
    const { data } = await firstValueFrom(
      this.httpService.post(
        `${this.baseUrl}/api/instances/${instanceId}/whatsapp/wait`,
        {},
        { headers: this.headers, timeout: 60000 },
      ),
    ).catch(this.rethrow);
    return data;
  }

  async getWhatsappStatus(instanceId: string) {
    const { data } = await firstValueFrom(
      this.httpService.get(`${this.baseUrl}/api/instances/${instanceId}/whatsapp/status`, {
        headers: this.headers,
      }),
    ).catch(this.rethrow);
    return data;
  }

  async setupTelegram(instanceId: string, botToken: string, accountId?: string) {
    const { data } = await firstValueFrom(
      this.httpService.post(
        `${this.baseUrl}/api/instances/${instanceId}/telegram/setup`,
        { botToken, ...(accountId ? { accountId } : {}) },
        { headers: this.headers },
      ),
    ).catch(this.rethrow);
    return data;
  }

  async getTelegramStatus(instanceId: string, probe?: boolean) {
    const { data } = await firstValueFrom(
      this.httpService.get(`${this.baseUrl}/api/instances/${instanceId}/telegram/status`, {
        headers: this.headers,
        params: probe ? { probe: "true" } : {},
        timeout: 20_000,
      }),
    ).catch(this.rethrow);
    return data;
  }

  async logoutTelegram(instanceId: string, accountId?: string) {
    const { data } = await firstValueFrom(
      this.httpService.post(
        `${this.baseUrl}/api/instances/${instanceId}/telegram/logout`,
        accountId ? { accountId } : {},
        { headers: this.headers },
      ),
    ).catch(this.rethrow);
    return data;
  }

  async setupDiscord(instanceId: string, botToken: string, accountId?: string) {
    const { data } = await firstValueFrom(
      this.httpService.post(
        `${this.baseUrl}/api/instances/${instanceId}/discord/setup`,
        { token: botToken, ...(accountId ? { accountId } : {}) },
        { headers: this.headers },
      ),
    ).catch(this.rethrow);
    return data;
  }

  async getDiscordStatus(instanceId: string, probe?: boolean) {
    const { data } = await firstValueFrom(
      this.httpService.get(`${this.baseUrl}/api/instances/${instanceId}/discord/status`, {
        headers: this.headers,
        params: probe ? { probe: "true" } : {},
        timeout: 20_000,
      }),
    ).catch(this.rethrow);
    return data;
  }

  async logoutDiscord(instanceId: string, accountId?: string) {
    const { data } = await firstValueFrom(
      this.httpService.post(
        `${this.baseUrl}/api/instances/${instanceId}/discord/logout`,
        accountId ? { accountId } : {},
        { headers: this.headers },
      ),
    ).catch(this.rethrow);
    return data;
  }

  async getAllChannelsStatus(instanceId: string, probe?: boolean) {
    const { data } = await firstValueFrom(
      this.httpService.get(`${this.baseUrl}/api/instances/${instanceId}/channels/status`, {
        headers: this.headers,
        params: probe ? { probe: "true" } : {},
        timeout: 20_000,
      }),
    ).catch(this.rethrow);
    return data;
  }

  async listPairing(instanceId: string, channel: string) {
    const { data } = await firstValueFrom(
      this.httpService.get(`${this.baseUrl}/api/instances/${instanceId}/pairing/list`, {
        headers: this.headers,
        params: { channel },
      }),
    ).catch(this.rethrow);
    return data;
  }

  async approvePairing(instanceId: string, channel: string, code: string, notify?: boolean) {
    const { data } = await firstValueFrom(
      this.httpService.post(
        `${this.baseUrl}/api/instances/${instanceId}/pairing/approve`,
        { channel, code, ...(notify != null ? { notify } : {}) },
        { headers: this.headers },
      ),
    ).catch(this.rethrow);
    return data;
  }

  async rpc(instanceId: string, body: unknown) {
    const { data } = await firstValueFrom(
      this.httpService.post(`${this.baseUrl}/api/instances/${instanceId}/rpc`, body, {
        headers: this.headers,
      }),
    ).catch(this.rethrow);
    return data;
  }

  async hubInstallSkill(instanceId: string, slug: string, version?: string) {
    const { data } = await firstValueFrom(
      this.httpService.post(
        `${this.baseUrl}/api/instances/${instanceId}/skills/hub-install`,
        { slug, ...(version ? { version } : {}) },
        { headers: this.headers, timeout: 120_000 },
      ),
    ).catch(this.rethrow);
    return data;
  }

  async hubUninstallSkill(instanceId: string, slug: string) {
    const { data } = await firstValueFrom(
      this.httpService.post(
        `${this.baseUrl}/api/instances/${instanceId}/skills/hub-uninstall`,
        { slug },
        { headers: this.headers, timeout: 60_000 },
      ),
    ).catch(this.rethrow);
    return data;
  }

  async hubListSkills(instanceId: string) {
    const { data } = await firstValueFrom(
      this.httpService.get(`${this.baseUrl}/api/instances/${instanceId}/skills/hub-list`, {
        headers: this.headers,
      }),
    ).catch(this.rethrow);
    return data;
  }
}
