import "reflect-metadata";
import { ValidationPipe } from "@nestjs/common";
import { ConfigService } from "@nestjs/config";
import { NestFactory } from "@nestjs/core";
import { JwtService } from "@nestjs/jwt";
import { DocumentBuilder, SwaggerModule } from "@nestjs/swagger";
import { AppModule } from "./app.module.js";
import { initChatProxy, handleChatUpgrade } from "./chat/chat-proxy.js";
import { PrismaService } from "./prisma/prisma.service.js";

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
      forbidNonWhitelisted: true,
      transform: true,
    }),
  );

  app.enableCors();

  if (process.env.NODE_ENV !== "production") {
    const config = new DocumentBuilder()
      .setTitle("OpenClaw API")
      .setDescription("OpenClaw App API — 인증, 인스턴스 관리, Manager 프록시")
      .setVersion("0.1.0")
      .addBearerAuth()
      .build();
    const document = SwaggerModule.createDocument(app, config);
    SwaggerModule.setup("docs", app, document);
  }

  const port = process.env.PORT ?? 4000;
  await app.listen(port);
  console.log(`openclaw-api listening on :${port}`);

  initChatProxy({
    jwt: app.get(JwtService),
    managerUrl: app.get(ConfigService).getOrThrow("MANAGER_URL"),
    managerApiKey: app.get(ConfigService).getOrThrow("MANAGER_API_KEY"),
    prisma: app.get(PrismaService),
  });

  const server = app.getHttpServer();
  server.on("upgrade", (req: any, socket: any, head: any) => {
    const url = new URL(req.url || "", `http://${req.headers.host}`);
    if (url.pathname.match(/^\/instances\/[^/]+\/chat$/)) {
      handleChatUpgrade(req, socket, head);
    }
  });
}

bootstrap();
