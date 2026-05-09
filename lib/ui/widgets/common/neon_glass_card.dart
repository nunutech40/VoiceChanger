import 'dart:ui';

import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

/// A glassmorphic card widget with neon accents.
///
/// Features:
/// - [BackdropFilter] blur for the glass effect (sigmaX/Y = 25).
/// - Semi-transparent background with subtle gradient border.
/// - Optional neon glow border for active / selected states.
class NeonGlassCard extends StatelessWidget {
  const NeonGlassCard({
    super.key,
    required this.child,
    this.borderRadius = 16.0,
    this.padding = const EdgeInsets.all(16.0),
    this.margin,
    this.isActive = false,
    this.blurSigma = 25.0,
    this.backgroundColor,
    this.borderGradient,
    this.width,
    this.height,
    this.clipBehavior = Clip.antiAlias,
  });

  /// The widget placed inside the glass card.
  final Widget child;

  /// Corner radius of the card.
  final double borderRadius;

  /// Inner padding around [child].
  final EdgeInsetsGeometry padding;

  /// Outer margin around the card.
  final EdgeInsetsGeometry? margin;

  /// Whether the card is in an active / selected state (shows neon border).
  final bool isActive;

  /// Blur intensity for the [BackdropFilter].
  final double blurSigma;

  /// Override the default glass background color.
  final Color? backgroundColor;

  /// Override the default border gradient.
  final Gradient? borderGradient;

  /// Fixed width (optional).
  final double? width;

  /// Fixed height (optional).
  final double? height;

  /// Clip behaviour.
  final Clip clipBehavior;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        clipBehavior: clipBehavior,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              color: backgroundColor ?? AppColors.glassSurface,
              border: Border.all(
                width: 1.0,
                color: isActive
                    ? AppColors.neonPrimary.withValues(alpha: 0.4)
                    : AppColors.glassBorder,
              ),
              gradient: isActive ? borderGradient : null,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// A glassmorphic container without the backdrop filter (lighter variant).
///
/// Useful when you need the glass look but the backdrop filter causes
/// layout or performance issues (e.g., inside scrollable lists).
class NeonGlassSurface extends StatelessWidget {
  const NeonGlassSurface({
    super.key,
    required this.child,
    this.borderRadius = 16.0,
    this.padding = const EdgeInsets.all(16.0),
    this.margin,
    this.isActive = false,
    this.backgroundColor,
    this.width,
    this.height,
  });

  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final bool isActive;
  final Color? backgroundColor;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        color: backgroundColor ?? AppColors.glassSurface,
        border: Border.all(
          width: 1.0,
          color: isActive
              ? AppColors.neonPrimary.withValues(alpha: 0.4)
              : AppColors.glassBorder,
        ),
      ),
      child: child,
    );
  }
}

/// A glassmorphic bottom navigation bar.
///
/// Sits at the bottom of the screen with a blur effect and
/// subtle gradient border on top.
class NeonGlassBottomNav extends StatelessWidget {
  const NeonGlassBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.items = const [],
    this.height = 72.0,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  /// Each item provides [icon] (IconData) and [label] (String).
  final List<NeonNavItem> items;
  final double height;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 25.0, sigmaY: 25.0),
        child: Container(
          height: height,
          decoration: const BoxDecoration(
            color: AppColors.glassSurface,
            border: Border(
              top: BorderSide(color: AppColors.glassBorder, width: 1.0),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(items.length, (index) {
              final item = items[index];
              final isSelected = index == currentIndex;
              return Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onTap(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 4.0,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      color: isSelected
                          ? AppColors.neonPrimary.withValues(alpha: 0.15)
                          : Colors.transparent,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          item.icon,
                          color: isSelected
                              ? AppColors.neonPrimary
                              : AppColors.textSecondary,
                          size: 24,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item.label,
                          style: TextStyle(
                            fontSize: 10,
                            color: isSelected
                                ? AppColors.neonPrimary
                                : AppColors.textSecondary,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

/// Data class for [NeonGlassBottomNav] items.
///
/// Each item provides an [icon] and [label] for the navigation bar.
class NeonNavItem {
  const NeonNavItem({required this.icon, required this.label});

  final IconData icon;
  final String label;
}
