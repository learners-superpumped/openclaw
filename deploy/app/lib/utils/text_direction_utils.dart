import 'dart:ui' show TextDirection;

/// Detect if text is primarily RTL (Arabic, Hebrew, etc.).
///
/// Returns [TextDirection.rtl] if the majority of directional characters
/// are RTL, otherwise [TextDirection.ltr].
TextDirection detectTextDirection(String text) {
  if (text.isEmpty) return TextDirection.ltr;

  int rtlCount = 0;
  int ltrCount = 0;

  for (final codeUnit in text.runes) {
    if (_isRtlChar(codeUnit)) {
      rtlCount++;
    } else if (_isLtrChar(codeUnit)) {
      ltrCount++;
    }
  }

  return rtlCount > ltrCount ? TextDirection.rtl : TextDirection.ltr;
}

bool _isRtlChar(int codePoint) {
  // Hebrew: U+0590–U+05FF
  if (codePoint >= 0x0590 && codePoint <= 0x05FF) return true;
  // Arabic: U+0600–U+06FF
  if (codePoint >= 0x0600 && codePoint <= 0x06FF) return true;
  // Arabic Supplement: U+0750–U+077F
  if (codePoint >= 0x0750 && codePoint <= 0x077F) return true;
  // Arabic Extended-A: U+08A0–U+08FF
  if (codePoint >= 0x08A0 && codePoint <= 0x08FF) return true;
  // Arabic Presentation Forms-A: U+FB50–U+FDFF
  if (codePoint >= 0xFB50 && codePoint <= 0xFDFF) return true;
  // Arabic Presentation Forms-B: U+FE70–U+FEFF
  if (codePoint >= 0xFE70 && codePoint <= 0xFEFF) return true;
  return false;
}

bool _isLtrChar(int codePoint) {
  // Basic Latin letters
  if (codePoint >= 0x0041 && codePoint <= 0x005A) return true;
  if (codePoint >= 0x0061 && codePoint <= 0x007A) return true;
  // Latin Extended
  if (codePoint >= 0x00C0 && codePoint <= 0x024F) return true;
  // CJK Unified Ideographs (treated as LTR)
  if (codePoint >= 0x4E00 && codePoint <= 0x9FFF) return true;
  // Hangul
  if (codePoint >= 0xAC00 && codePoint <= 0xD7AF) return true;
  // Hiragana
  if (codePoint >= 0x3040 && codePoint <= 0x309F) return true;
  // Katakana
  if (codePoint >= 0x30A0 && codePoint <= 0x30FF) return true;
  return false;
}
