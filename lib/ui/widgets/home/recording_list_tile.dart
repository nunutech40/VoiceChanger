import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../common/neon_glass_card.dart';

/// A recording list tile wrapped in a glass card.
///
/// Features:
/// - Uses NeonGlassCard for the glassmorphic container
/// - Clear hierarchy: Title (white), Date/Time (grey/blueish)
/// - Trailing ghost menu button
/// - Leading play icon with neon accent glow
class RecordingListTile extends StatelessWidget {
  const RecordingListTile({
    super.key,
    required this.title,
    required this.subtitle,
    this.duration,
    this.onPlay,
    this.onMenu,
    this.isActive = false,
  });

  final String title;
  final String subtitle;
  final String? duration;
  final VoidCallback? onPlay;
  final VoidCallback? onMenu;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return NeonGlassCard(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
      isActive: isActive,
      child: Row(
        children: [
          // Leading play button with neon accent
          GestureDetector(
            onTap: onPlay,
            child: Container(
              width: 40.0,
              height: 40.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive
                    ? AppColors.neonPrimary.withValues(alpha: 0.15)
                    : AppColors.glassSurface,
                border: Border.all(
                  color: isActive
                      ? AppColors.neonPrimary.withValues(alpha: 0.4)
                      : AppColors.glassBorder,
                  width: 1.0,
                ),
              ),
              child: Icon(
                isActive ? Icons.play_arrow : Icons.play_arrow_rounded,
                color: isActive
                    ? AppColors.neonPrimary
                    : AppColors.textSecondary,
                size: 20.0,
              ),
            ),
          ),
          const SizedBox(width: 12.0),

          // Title and subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2.0),
                Row(
                  children: [
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12.0,
                      ),
                    ),
                    if (duration != null) ...[
                      const SizedBox(width: 8.0),
                      Text(
                        '• $duration',
                        style: const TextStyle(
                          color: AppColors.textHint,
                          fontSize: 12.0,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),

          // Trailing ghost menu button
          GestureDetector(
            onTap: onMenu,
            child: Container(
              width: 32.0,
              height: 32.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
              ),
              child: Icon(
                Icons.more_horiz_rounded,
                color: AppColors.textHint,
                size: 20.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
