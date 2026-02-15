import { Controller, Get, Header } from "@nestjs/common";
import { readFileSync } from "fs";
import { join } from "path";
import { Public } from "../auth/public.decorator.js";

const privacyHtml = readFileSync(join(import.meta.dirname, "privacy.html"), "utf-8");

@Controller("legal")
export class LegalController {
  @Public()
  @Get("privacy")
  @Header("Content-Type", "text/html")
  privacy() {
    return privacyHtml;
  }
}
