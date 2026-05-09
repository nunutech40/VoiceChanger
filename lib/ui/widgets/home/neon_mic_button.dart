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
    with TickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final AnimationController _pressController;
  late final Animation<double> _pulseAnimation;
  late final Animation<double> _pressAnimation;

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

    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
      reverseDuration: const Duration(milliseconds: 420),
    );

    _pressAnimation = CurvedAnimation(
      parent: _pressController,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeOutExpo,
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _pressController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _pressController.forward();
  }

  void _handleTapEnd() {
    _pressController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_pulseAnimation, _pressAnimation]),
      builder: (context, child) {
        final pulse = _pulseAnimation.value;
        final press = _pressAnimation.value;
        final activeEnergy = widget.isRecording ? 1.0 : press;
        final scale =
            (widget.isRecording ? 1.0 + (pulse * 0.026) : 1.0) -
            (press * 0.035);
        final ringOpacity = widget.isRecording ? 0.9 : 0.62;
        final rippleScale = 0.82 + (press * 0.34) + (pulse * 0.04);
        final rippleOpacity = (press * 0.36) + (widget.isRecording ? 0.14 : 0);

        return Semantics(
          button: true,
          label: widget.isRecording ? 'Stop recording' : 'Start recording',
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: _handleTapDown,
            onTapUp: (_) => _handleTapEnd(),
            onTapCancel: _handleTapEnd,
            onTap: widget.onPressed,
            onLongPress: widget.onLongPress,
            child: SizedBox.square(
              dimension: widget.size,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Transform.scale(
                    scale: rippleScale,
                    child: Container(
                      width: widget.size,
                      height: widget.size,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.neonPrimary.withValues(
                            alpha: rippleOpacity.clamp(0, 0.5),
                          ),
                          width: 2.0 + (press * 2.0),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.neonPrimary.withValues(
                              alpha: rippleOpacity * 0.45,
                            ),
                            blurRadius: widget.size * 0.18,
                            spreadRadius: widget.size * 0.02,
                          ),
                        ],
                      ),
                    ),
                  ),
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
                              alpha:
                                  0.16 + (pulse * 0.08) + (activeEnergy * 0.1),
                            ),
                            blurRadius: widget.size * 0.24,
                            spreadRadius:
                                widget.size * (0.02 + (activeEnergy * 0.018)),
                          ),
                          BoxShadow(
                            color: AppColors.neonSecondary.withValues(
                              alpha:
                                  0.22 + (pulse * 0.08) + (activeEnergy * 0.1),
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
                        color: Colors.white.withValues(
                          alpha: 0.08 + (activeEnergy * 0.08),
                        ),
                        width: 1 + (press * 0.8),
                      ),
                    ),
                  ),
                  Transform.scale(
                    scale: 1 - (press * 0.04),
                    child: Container(
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
                            color: AppColors.neonPrimary.withValues(
                              alpha: 0.18 + (activeEnergy * 0.14),
                            ),
                            blurRadius: 30 + (activeEnergy * 16),
                            offset: const Offset(0, 12),
                          ),
                        ],
                      ),
                      child: Icon(
                        widget.isRecording
                            ? Icons.stop_rounded
                            : Icons.mic_none_rounded,
                        color: const Color(0xFF5261F6),
                        size: widget.size * (0.28 + (press * 0.015)),
                      ),
                    ),
                  ),
                  if (widget.isRecording || press > 0)
                    Positioned(
                      bottom: widget.size * 0.16,
                      child: Opacity(
                        opacity: (0.42 + (activeEnergy * 0.42)).clamp(0, 1),
                        child: _MicEnergyBars(
                          color: widget.isRecording
                              ? AppColors.neonPrimary
                              : AppColors.neonSecondary,
                          progress: pulse,
                          intensity: activeEnergy,
                        ),
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

class _MicEnergyBars extends StatelessWidget {
  const _MicEnergyBars({
    required this.color,
    required this.progress,
    required this.intensity,
  });

  final Color color;
  final double progress;
  final double intensity;

  @override
  Widget build(BuildContext context) {
    const heights = [8.0, 15.0, 22.0, 16.0, 10.0];

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(heights.length, (index) {
        final phase = (progress + (index * 0.16)) % 1;
        final bounce = phase < 0.5 ? phase * 2 : (1 - phase) * 2;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOutCubic,
          width: 3,
          height: heights[index] + (bounce * 8 * intensity),
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: color.withValues(alpha: 0.78),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.32),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
        );
      }),
    );
  }
}
