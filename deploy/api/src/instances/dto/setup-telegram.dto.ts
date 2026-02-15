import { IsOptional, IsString } from "class-validator";

export class SetupTelegramDto {
  @IsString()
  botToken!: string;

  @IsOptional()
  @IsString()
  accountId?: string;
}
