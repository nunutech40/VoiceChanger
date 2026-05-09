import 'dart:ui';

/// Dark Neon Glassmorphism Design Tokens
///
/// Central theme colors for the "Dark Neon Glassmorphism" aesthetic.
/// All widgets should reference these constants for consistency.
class AppColors {
  AppColors._();

  // ──────────────────────────────────────────────
  // Background
  // ──────────────────────────────────────────────
  /// Deep midnight black/navy background.
  static const Color backgroundDeep = Color(0xFF0A0C14);

  /// Slightly lighter surface for cards / elevated panels.
  static const Color surfaceDark = Color(0xFF12141E);

  // ──────────────────────────────────────────────
  // Neon Glows
  // ──────────────────────────────────────────────
  /// Primary neon: Cyan / Electric Blue.
  static const Color neonPrimary = Color(0xFF4D9FFF);

  /// Secondary neon: Purple / Magenta.
  static const Color neonSecondary = Color(0xFFBD5CFF);

  // ──────────────────────────────────────────────
  // Glassmorphism
  // ──────────────────────────────────────────────
  /// Glass surface – 10% white with blur.
  static const Color glassSurface = Color(0x1AFFFFFF);

  /// Glass border – 20% white.
  static const Color glassBorder = Color(0x33FFFFFF);

  /// Slightly brighter glass for elevated elements.
  static const Color glassSurfaceElevated = Color(0x26FFFFFF);

  // ──────────────────────────────────────────────
  // Text
  // ──────────────────────────────────────────────
  /// Primary text on dark backgrounds.
  static const Color textPrimary = Color(0xFFFFFFFF);

  /// Secondary / muted text.
  static const Color textSecondary = Color(0xB3FFFFFF);

  /// Disabled / hint text.
  static const Color textHint = Color(0x66FFFFFF);

  // ──────────────────────────────────────────────
  // Semantic
  // ──────────────────────────────────────────────
  static const Color success = Color(0xFF34D399);
  static const Color warning = Color(0xFFFBBF24);
  static const Color error = Color(0xFFEF4444);
}
