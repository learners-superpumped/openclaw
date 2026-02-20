import { Body, Controller, Delete, Get, Inject, Param, Post, Query, Request } from "@nestjs/common";
import { ApiBearerAuth, ApiOperation, ApiTags } from "@nestjs/swagger";
import { Public } from "../auth/public.decorator.js";
import { ClawHubService } from "./clawhub.service.js";
import { InstallSkillDto } from "./dto/install-skill.dto.js";
import { ListSkillsDto } from "./dto/list-skills.dto.js";

@ApiTags("ClawHub")
@Controller("clawhub")
export class ClawHubController {
  constructor(@Inject(ClawHubService) private clawHubService: ClawHubService) {}

  // ── Public proxy endpoints ──

  @Public()
  @Get("skills")
  @ApiOperation({ summary: "ClawHub 스킬 리스트" })
  listSkills(@Query() query: ListSkillsDto) {
    return this.clawHubService.listSkills(query);
  }

  @Public()
  @Get("skills/:slug")
  @ApiOperation({ summary: "ClawHub 스킬 상세" })
  getSkill(@Param("slug") slug: string) {
    return this.clawHubService.getSkill(slug);
  }

  @Public()
  @Get("skills/:slug/versions")
  @ApiOperation({ summary: "ClawHub 스킬 버전 목록" })
  getSkillVersions(@Param("slug") slug: string) {
    return this.clawHubService.getSkillVersions(slug);
  }

  // ── Instance-scoped endpoints (JWT required) ──

  @ApiBearerAuth()
  @Get("instances/:instanceId/skills")
  @ApiOperation({ summary: "설치된 스킬 목록" })
  getInstalledSkills(@Request() req: any, @Param("instanceId") instanceId: string) {
    return this.clawHubService.getInstalledSkills(req.user.sub, instanceId);
  }

  @ApiBearerAuth()
  @Post("instances/:instanceId/skills")
  @ApiOperation({ summary: "스킬 설치" })
  installSkill(
    @Request() req: any,
    @Param("instanceId") instanceId: string,
    @Body() dto: InstallSkillDto,
  ) {
    return this.clawHubService.installSkill(req.user.sub, instanceId, dto.slug, dto.version);
  }

  @ApiBearerAuth()
  @Delete("instances/:instanceId/skills/:slug")
  @ApiOperation({ summary: "스킬 제거" })
  uninstallSkill(
    @Request() req: any,
    @Param("instanceId") instanceId: string,
    @Param("slug") slug: string,
  ) {
    return this.clawHubService.uninstallSkill(req.user.sub, instanceId, slug);
  }

  @ApiBearerAuth()
  @Get("instances/:instanceId/browse")
  @ApiOperation({ summary: "설치상태 포함 스킬 리스트" })
  browseSkills(
    @Request() req: any,
    @Param("instanceId") instanceId: string,
    @Query() query: ListSkillsDto,
  ) {
    return this.clawHubService.browseSkills(req.user.sub, instanceId, query);
  }

  @ApiBearerAuth()
  @Get("instances/:instanceId/browse/:slug")
  @ApiOperation({ summary: "설치상태 포함 스킬 상세" })
  browseSkillDetail(
    @Request() req: any,
    @Param("instanceId") instanceId: string,
    @Param("slug") slug: string,
  ) {
    return this.clawHubService.browseSkillDetail(req.user.sub, instanceId, slug);
  }
}
