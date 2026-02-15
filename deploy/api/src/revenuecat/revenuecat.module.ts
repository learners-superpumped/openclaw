import { HttpModule } from "@nestjs/axios";
import { Module } from "@nestjs/common";
import { RevenueCatService } from "./revenuecat.service.js";

@Module({
  imports: [HttpModule],
  providers: [RevenueCatService],
  exports: [RevenueCatService],
})
export class RevenueCatModule {}
