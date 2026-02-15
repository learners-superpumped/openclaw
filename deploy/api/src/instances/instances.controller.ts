import { Body, Controller, Delete, Get, Inject, Param, Post, Query, Request } from "@nestjs/common";
import { ApiBearerAuth, ApiOperation, ApiTags } from "@nestjs/swagger";
import { ApprovePairingDto } from "./dto/approve-pairing.dto.js";
import { CreateInstanceDto } from "./dto/create-instance.dto.js";
import { SetupTelegramDto } from "./dto/setup-telegram.dto.js";
import { InstancesService } from "./instances.service.js";

@ApiTags("Instances")
@ApiBearerAuth()
@Controller("instances")
export class InstancesController {
  constructor(@Inject(InstancesService) private instancesService: InstancesService) {}

  @Post()
  @ApiOperation({ summary: "인스턴스 생성" })
  create(@Request() req: any, @Body() dto: CreateInstanceDto) {
    return this.instancesService.create(req.user.sub, dto);
  }

  @Get()
  @ApiOperation({ summary: "내 인스턴스 목록" })
  findAll(@Request() req: any) {
    return this.instancesService.findAllByUser(req.user.sub);
  }

  @Get(":instanceId")
  @ApiOperation({ summary: "인스턴스 상세 조회" })
  findOne(@Request() req: any, @Param("instanceId") instanceId: string) {
    return this.instancesService.findOne(req.user.sub, instanceId);
  }

  @Delete(":instanceId")
  @ApiOperation({ summary: "인스턴스 삭제" })
  remove(@Request() req: any, @Param("instanceId") instanceId: string) {
    return this.instancesService.remove(req.user.sub, instanceId);
  }

  @Post(":instanceId/whatsapp/qr")
  @ApiOperation({ summary: "WhatsApp QR 요청" })
  requestQr(@Request() req: any, @Param("instanceId") instanceId: string) {
    return this.instancesService.requestQr(req.user.sub, instanceId);
  }

  @Post(":instanceId/whatsapp/wait")
  @ApiOperation({ summary: "WhatsApp QR 대기" })
  waitForQr(@Request() req: any, @Param("instanceId") instanceId: string) {
    return this.instancesService.waitForQr(req.user.sub, instanceId);
  }

  @Get(":instanceId/whatsapp/status")
  @ApiOperation({ summary: "WhatsApp 연결 상태" })
  getWhatsappStatus(@Request() req: any, @Param("instanceId") instanceId: string) {
    return this.instancesService.getWhatsappStatus(req.user.sub, instanceId);
  }

  @Post(":instanceId/telegram/setup")
  @ApiOperation({ summary: "Telegram 봇 토큰 설정" })
  setupTelegram(
    @Request() req: any,
    @Param("instanceId") instanceId: string,
    @Body() dto: SetupTelegramDto,
  ) {
    return this.instancesService.setupTelegram(
      req.user.sub,
      instanceId,
      dto.botToken,
      dto.accountId,
    );
  }

  @Get(":instanceId/telegram/status")
  @ApiOperation({ summary: "Telegram 연결 상태" })
  getTelegramStatus(
    @Request() req: any,
    @Param("instanceId") instanceId: string,
    @Query("probe") probe?: string,
  ) {
    return this.instancesService.getTelegramStatus(req.user.sub, instanceId, probe === "true");
  }

  @Post(":instanceId/telegram/logout")
  @ApiOperation({ summary: "Telegram 연결 해제" })
  logoutTelegram(
    @Request() req: any,
    @Param("instanceId") instanceId: string,
    @Body() body: { accountId?: string },
  ) {
    return this.instancesService.logoutTelegram(req.user.sub, instanceId, body.accountId);
  }

  @Get(":instanceId/pairing/list")
  @ApiOperation({ summary: "페어링 요청 조회" })
  listPairing(
    @Request() req: any,
    @Param("instanceId") instanceId: string,
    @Query("channel") channel: string,
  ) {
    return this.instancesService.listPairing(req.user.sub, instanceId, channel);
  }

  @Post(":instanceId/pairing/approve")
  @ApiOperation({ summary: "페어링 승인" })
  approvePairing(
    @Request() req: any,
    @Param("instanceId") instanceId: string,
    @Body() dto: ApprovePairingDto,
  ) {
    return this.instancesService.approvePairing(
      req.user.sub,
      instanceId,
      dto.channel,
      dto.code,
      dto.notify,
    );
  }

  @Post(":instanceId/rpc")
  @ApiOperation({ summary: "RPC 호출" })
  rpc(@Request() req: any, @Param("instanceId") instanceId: string, @Body() body: unknown) {
    return this.instancesService.rpc(req.user.sub, instanceId, body);
  }
}
