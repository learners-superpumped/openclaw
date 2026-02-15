import { IsObject, IsOptional, IsString } from "class-validator";

export class CreateInstanceDto {
  @IsOptional()
  @IsString()
  displayName?: string;

  @IsObject()
  secrets!: Record<string, string>;
}
