import { Injectable } from "@nestjs/common";

@Injectable()
export class PromoService {
  private readonly validCodes = new Set(["CLAWBOX-REVIEW-2026"]);

  isValidCode(code: string): boolean {
    return this.validCodes.has(code.toUpperCase());
  }
}
