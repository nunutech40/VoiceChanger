import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

/// A hero mic button with neon glow and breathing animation.
///
/// Features:
/// - Floating orb with layered BoxShadow for smooth neon glow
/// - Breathing/pulsing animation via AnimationController
/// - Subtle scale-up on tap
/// - Clean minimalist mic icon
class NeonMicButton extends StatefulWidget {
  const NeonMicButton({
    super.key,
    this.onPressed,
    this.onLongPress,
    this.size = 80.0,
    this.isRecording = false,
  });

  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final double size;
  final bool isRecording;

  @override
  State<NeonMicButton> createState() => _NeonMicButtonState();
}

class _NeonMicButtonState extends State<NeonMicButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOutSine),
    );
  }

  @override
  void didUpdateWidget(NeonMicButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isRecording != oldWidget.isRecording) {
      if (widget.isRecording) {
        _pulseController.repeat(reverse: true);
      } else {
        _pulseController.repeat(reverse: true); // tetap breathing walau idle
      }
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        final pulseValue = _pulseAnimation.value;
        final glowColor = widget.isRecording
            ? AppColors.neonPrimary
            : AppColors.neonSecondary;

        return Transform.scale(
          scale: pulseValue,
          child: GestureDetector(
            onTap: widget.onPressed,
            onLongPress: widget.onLongPress,
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.surfaceDark,
                boxShadow: [
                  // Inner glow
                  BoxShadow(
                    color: glowColor.withValues(alpha: 0.3 * pulseValue),
                    blurRadius: widget.size * 0.4,
                    spreadRadius: widget.size * 0.1,
                  ),
                  // Mid glow
                  BoxShadow(
                    color: glowColor.withValues(alpha: 0.15 * pulseValue),
                    blurRadius: widget.size * 0.7,
                    spreadRadius: widget.size * 0.05,
                  ),
                  // Outer aura
                  BoxShadow(
                    color: glowColor.withValues(alpha: 0.08 * pulseValue),
                    blurRadius: widget.size * 1.0,
                    spreadRadius: widget.size * 0.02,
                  ),
                ],
              ),
              child: Container(
                margin: const EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.backgroundDeep,
                  border: Border.all(
                    color: glowColor.withValues(alpha: 0.4),
                    width: 1.5,
                  ),
                ),
                child: Icon(
                  widget.isRecording ? Icons.mic : Icons.mic_none,
                  color: glowColor,
                  size: widget.size * 0.4,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
