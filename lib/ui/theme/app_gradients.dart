import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Dark Neon Glassmorphism Gradients
///
/// Pre-defined gradients for backgrounds, neon pulses, and glass overlays.
class AppGradients {
  AppGradients._();

  // ──────────────────────────────────────────────
  // Background Gradients
  // ──────────────────────────────────────────────

  /// Deep midnight background with a subtle radial blue glow.
  static final backgroundRadial = RadialGradient(
    center: Alignment.center,
    radius: 1.2,
    colors: [
      AppColors.neonPrimary.withValues(alpha: 0.08),
      AppColors.backgroundDeep,
      AppColors.backgroundDeep,
    ],
    stops: const [0.0, 0.5, 1.0],
  );

  /// Deep midnight background with a subtle purple glow.
  static final backgroundRadialPurple = RadialGradient(
    center: Alignment.bottomRight,
    radius: 1.4,
    colors: [
      AppColors.neonSecondary.withValues(alpha: 0.06),
      AppColors.backgroundDeep,
      AppColors.backgroundDeep,
    ],
    stops: const [0.0, 0.5, 1.0],
  );

  /// Full-screen layered background (cyan + purple corners).
  static final backgroundLayered = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.neonPrimary.withValues(alpha: 0.05),
      AppColors.backgroundDeep,
      AppColors.neonSecondary.withValues(alpha: 0.05),
    ],
    stops: const [0.0, 0.5, 1.0],
  );

  // ──────────────────────────────────────────────
  // Neon Pulse Gradients
  // ──────────────────────────────────────────────

  /// Cyan neon glow (use for active / recording states).
  static final neonPulsePrimary = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.neonPrimary.withValues(alpha: 0.3),
      AppColors.neonPrimary.withValues(alpha: 0.05),
    ],
  );

  /// Purple neon glow (use for secondary actions / tuner).
  static final neonPulseSecondary = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.neonSecondary.withValues(alpha: 0.3),
      AppColors.neonSecondary.withValues(alpha: 0.05),
    ],
  );

  // ──────────────────────────────────────────────
  // Glass Border Gradients
  // ──────────────────────────────────────────────

  /// Subtle gradient border for glassmorphic containers.
  static final glassBorderGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Colors.white.withValues(alpha: 0.25),
      Colors.white.withValues(alpha: 0.05),
      Colors.white.withValues(alpha: 0.15),
    ],
    stops: const [0.0, 0.5, 1.0],
  );

  /// Brighter border for active / selected glass elements.
  static final glassBorderActive = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.neonPrimary.withValues(alpha: 0.4),
      AppColors.neonSecondary.withValues(alpha: 0.2),
    ],
  );
}
