import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPlay,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 62,
          margin: const EdgeInsets.symmetric(vertical: 3),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              _PlayButton(isActive: isActive),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                        height: 1.2,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                        height: 1.2,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              if (duration != null) ...[
                const SizedBox(width: 8),
                Text(
                  duration!,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    height: 1,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
              IconButton(
                onPressed: onMenu,
                visualDensity: VisualDensity.compact,
                icon: const Icon(
                  Icons.more_vert_rounded,
                  color: AppColors.textSecondary,
                  size: 22,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlayButton extends StatelessWidget {
  const _PlayButton({required this.isActive});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.neonPrimary.withValues(alpha: isActive ? 1 : 0.95),
            AppColors.neonSecondary.withValues(alpha: isActive ? 1 : 0.95),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.neonSecondary.withValues(alpha: 0.24),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: const Icon(
        Icons.play_arrow_rounded,
        color: Colors.white,
        size: 24,
      ),
    );
  }
}
