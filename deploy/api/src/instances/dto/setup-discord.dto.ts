import { IsOptional, IsString } from "class-validator";

export class SetupDiscordDto {
  @IsString()
  botToken!: string;

  @IsOptional()
  @IsString()
  accountId?: string;
}
