import { HttpService } from "@nestjs/axios";
import { Inject, Injectable } from "@nestjs/common";
import { ConfigService } from "@nestjs/config";
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

  async createInstance(instanceId: string, secrets: Record<string, string>) {
    const { data } = await firstValueFrom(
      this.httpService.post(
        `${this.baseUrl}/api/instances`,
        { userId: instanceId, secrets },
        { headers: this.headers },
      ),
    );
    return data;
  }

  async getInstance(instanceId: string) {
    const { data } = await firstValueFrom(
      this.httpService.get(`${this.baseUrl}/api/instances/${instanceId}`, {
        headers: this.headers,
      }),
    );
    return data;
  }

  async deleteInstance(instanceId: string) {
    const { data } = await firstValueFrom(
      this.httpService.delete(`${this.baseUrl}/api/instances/${instanceId}`, {
        headers: this.headers,
        params: { preservePvc: "false" },
      }),
    );
    return data;
  }

  async requestQr(instanceId: string) {
    const { data } = await firstValueFrom(
      this.httpService.post(
        `${this.baseUrl}/api/instances/${instanceId}/whatsapp/qr`,
        {},
        { headers: this.headers },
      ),
    );
    return data;
  }

  async waitForQr(instanceId: string) {
    const { data } = await firstValueFrom(
      this.httpService.post(
        `${this.baseUrl}/api/instances/${instanceId}/whatsapp/wait`,
        {},
        { headers: this.headers, timeout: 60000 },
      ),
    );
    return data;
  }

  async getWhatsappStatus(instanceId: string) {
    const { data } = await firstValueFrom(
      this.httpService.get(`${this.baseUrl}/api/instances/${instanceId}/whatsapp/status`, {
        headers: this.headers,
      }),
    );
    return data;
  }

  async setupTelegram(instanceId: string, botToken: string, accountId?: string) {
    const { data } = await firstValueFrom(
      this.httpService.post(
        `${this.baseUrl}/api/instances/${instanceId}/telegram/setup`,
        { botToken, ...(accountId ? { accountId } : {}) },
        { headers: this.headers },
      ),
    );
    return data;
  }

  async getTelegramStatus(instanceId: string, probe?: boolean) {
    const { data } = await firstValueFrom(
      this.httpService.get(`${this.baseUrl}/api/instances/${instanceId}/telegram/status`, {
        headers: this.headers,
        params: probe ? { probe: "true" } : {},
        timeout: 20_000,
      }),
    );
    return data;
  }

  async logoutTelegram(instanceId: string, accountId?: string) {
    const { data } = await firstValueFrom(
      this.httpService.post(
        `${this.baseUrl}/api/instances/${instanceId}/telegram/logout`,
        accountId ? { accountId } : {},
        { headers: this.headers },
      ),
    );
    return data;
  }

  async listPairing(instanceId: string, channel: string) {
    const { data } = await firstValueFrom(
      this.httpService.get(`${this.baseUrl}/api/instances/${instanceId}/pairing/list`, {
        headers: this.headers,
        params: { channel },
      }),
    );
    return data;
  }

  async approvePairing(instanceId: string, channel: string, code: string, notify?: boolean) {
    const { data } = await firstValueFrom(
      this.httpService.post(
        `${this.baseUrl}/api/instances/${instanceId}/pairing/approve`,
        { channel, code, ...(notify != null ? { notify } : {}) },
        { headers: this.headers },
      ),
    );
    return data;
  }

  async rpc(instanceId: string, body: unknown) {
    const { data } = await firstValueFrom(
      this.httpService.post(`${this.baseUrl}/api/instances/${instanceId}/rpc`, body, {
        headers: this.headers,
      }),
    );
    return data;
  }
}
