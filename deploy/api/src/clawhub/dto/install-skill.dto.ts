import { IsOptional, IsString } from "class-validator";

export class InstallSkillDto {
  @IsString()
  slug!: string;

  @IsOptional()
  @IsString()
  version?: string;
}
