import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

class NeonMicButton extends StatefulWidget {
  const NeonMicButton({
    super.key,
    this.onPressed,
    this.onLongPress,
    this.size = 188.0,
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
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOutSine),
    );
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
        final pulse = _pulseAnimation.value;
        final scale = widget.isRecording ? 1.0 + (pulse * 0.035) : 1.0;
        final ringOpacity = widget.isRecording ? 0.9 : 0.62;

        return Semantics(
          button: true,
          label: widget.isRecording ? 'Stop recording' : 'Start recording',
          child: GestureDetector(
            onTap: widget.onPressed,
            onLongPress: widget.onLongPress,
            child: SizedBox.square(
              dimension: widget.size,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Transform.scale(
                    scale: scale,
                    child: Container(
                      width: widget.size,
                      height: widget.size,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: SweepGradient(
                          colors: [
                            AppColors.neonPrimary.withValues(alpha: 0.05),
                            AppColors.neonPrimary.withValues(alpha: 0.58),
                            AppColors.neonSecondary.withValues(
                              alpha: ringOpacity,
                            ),
                            AppColors.neonPrimary.withValues(alpha: 0.08),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.neonPrimary.withValues(
                              alpha: 0.16 + (pulse * 0.08),
                            ),
                            blurRadius: widget.size * 0.24,
                            spreadRadius: widget.size * 0.02,
                          ),
                          BoxShadow(
                            color: AppColors.neonSecondary.withValues(
                              alpha: 0.22 + (pulse * 0.08),
                            ),
                            blurRadius: widget.size * 0.2,
                            spreadRadius: 0,
                            offset: Offset(0, widget.size * 0.1),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: widget.size * 0.84,
                    height: widget.size * 0.84,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF19213A),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.08),
                        width: 1,
                      ),
                    ),
                  ),
                  Container(
                    width: widget.size * 0.7,
                    height: widget.size * 0.7,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white,
                          Color(0xFFF6F8FF),
                          Color(0xFFE9ECFF),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withValues(alpha: 0.18),
                          blurRadius: 18,
                          offset: const Offset(-4, -6),
                        ),
                        BoxShadow(
                          color: AppColors.neonPrimary.withValues(alpha: 0.18),
                          blurRadius: 30,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    child: Icon(
                      widget.isRecording
                          ? Icons.stop_rounded
                          : Icons.mic_none_rounded,
                      color: const Color(0xFF5261F6),
                      size: widget.size * 0.28,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
