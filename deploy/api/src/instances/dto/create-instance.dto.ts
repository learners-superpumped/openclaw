import { IsOptional, IsString } from "class-validator";

export class CreateInstanceDto {
  @IsOptional()
  @IsString()
  displayName?: string;
}
