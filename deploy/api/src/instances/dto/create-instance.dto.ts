import { Type } from "class-transformer";
import { IsOptional, IsString, ValidateNested } from "class-validator";

export class UserProfileDto {
  @IsOptional()
  @IsString()
  name?: string;

  @IsOptional()
  @IsString()
  callName?: string;

  @IsOptional()
  @IsString()
  pronouns?: string;

  @IsOptional()
  @IsString()
  timezone?: string;

  @IsOptional()
  @IsString()
  notes?: string;
}

export class AgentProfileDto {
  @IsOptional()
  @IsString()
  name?: string;

  @IsOptional()
  @IsString()
  creature?: string;

  @IsOptional()
  @IsString()
  vibe?: string;

  @IsOptional()
  @IsString()
  emoji?: string;

  @IsOptional()
  @IsString()
  avatar?: string;
}

export class ProfileDto {
  @IsOptional()
  @ValidateNested()
  @Type(() => UserProfileDto)
  user?: UserProfileDto;

  @IsOptional()
  @ValidateNested()
  @Type(() => AgentProfileDto)
  agent?: AgentProfileDto;
}

export class CreateInstanceDto {
  @IsOptional()
  @IsString()
  displayName?: string;

  @IsOptional()
  @ValidateNested()
  @Type(() => ProfileDto)
  profile?: ProfileDto;
}
