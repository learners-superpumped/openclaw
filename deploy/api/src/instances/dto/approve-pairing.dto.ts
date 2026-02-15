import { IsBoolean, IsOptional, IsString } from "class-validator";

export class ApprovePairingDto {
  @IsString()
  channel!: string;

  @IsString()
  code!: string;

  @IsOptional()
  @IsBoolean()
  notify?: boolean;
}
