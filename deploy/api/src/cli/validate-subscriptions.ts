import "reflect-metadata";
import { NestFactory } from "@nestjs/core";
import { AppModule } from "../app.module.js";
import { SubscriptionService } from "../subscription/subscription.service.js";

async function main() {
  const app = await NestFactory.createApplicationContext(AppModule);
  const subscriptionService = app.get(SubscriptionService);
  await subscriptionService.validateSubscriptions();
  await app.close();
}

main();
