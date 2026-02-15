import { HttpService } from "@nestjs/axios";
import { Inject, Injectable } from "@nestjs/common";
import { ConfigService } from "@nestjs/config";
import { firstValueFrom } from "rxjs";

interface ActiveEntitlement {
  object: "customer.active_entitlement";
  entitlement_id: string;
  expires_at: number | null;
}

interface ActiveEntitlementsResponse {
  object: "list";
  items: ActiveEntitlement[];
  next_page: string | null;
  url: string;
}

@Injectable()
export class RevenueCatService {
  private readonly secretKey: string;
  private readonly projectId: string;

  constructor(
    @Inject(HttpService) private httpService: HttpService,
    @Inject(ConfigService) configService: ConfigService,
  ) {
    this.secretKey = configService.getOrThrow<string>("REVENUECAT_SECRET_API_KEY");
    this.projectId = configService.getOrThrow<string>("REVENUECAT_PROJECT_ID");
  }

  async isEntitlementActive(appUserId: string): Promise<boolean> {
    const { data } = await firstValueFrom(
      this.httpService.get<ActiveEntitlementsResponse>(
        `https://api.revenuecat.com/v2/projects/${this.projectId}/customers/${appUserId}/active_entitlements`,
        { headers: { Authorization: `Bearer ${this.secretKey}` } },
      ),
    );

    return data.items.length > 0;
  }
}
