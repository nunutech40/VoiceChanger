import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../ui/theme/app_colors.dart';
import '../../ui/widgets/common/neon_glass_card.dart';
import '../../ui/widgets/home/neon_mic_button.dart';
import '../../ui/widgets/home/recording_list_tile.dart';
import '../bloc/aura_voice_cubit.dart';
import '../bloc/aura_voice_state.dart';
import 'full_history_page.dart';
import 'playback_template_page.dart';

class HomeRecordPage extends StatelessWidget {
  const HomeRecordPage({super.key});

  static const double _contentMaxWidth = 430;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDeep,
      extendBody: true,
      body: BlocConsumer<AuraVoiceCubit, AuraVoiceState>(
        listener: (context, state) {
          if (state is AuraVoiceError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.message,
                  style: const TextStyle(color: Colors.white),
                ),
                backgroundColor: AppColors.error,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            );
          } else if (state is AuraVoicePlayback) {
            final cubit = context.read<AuraVoiceCubit>();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PlaybackTemplatePage(audioPath: state.filePath),
              ),
            ).then((_) {
              cubit.resetToReady();
            });
          }
        },
        builder: (context, state) {
          if (state is AuraVoiceInitial) {
            return const DecoratedBox(
              decoration: BoxDecoration(gradient: _HomeBackground.gradient),
              child: Center(
                child: CircularProgressIndicator(color: AppColors.neonPrimary),
              ),
            );
          }

          final isRecording = state is AuraVoiceRecording;

          return LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final isCompactHeight = constraints.maxHeight < 760;
              final micSize = width < 380 ? 166.0 : 188.0;
              final heroGap = isCompactHeight ? 14.0 : 24.0;

              return Stack(
                children: [
                  const Positioned.fill(child: _HomeBackground()),
                  SafeArea(
                    bottom: false,
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: _contentMaxWidth,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
                          child: Column(
                            children: [
                              _HomeHeader(
                                onImportPressed: () {
                                  context
                                      .read<AuraVoiceCubit>()
                                      .pickExternalFile();
                                },
                              ),
                              SizedBox(height: isCompactHeight ? 28 : 42),
                              NeonMicButton(
                                size: micSize,
                                isRecording: isRecording,
                                onPressed: () {
                                  if (isRecording) {
                                    context
                                        .read<AuraVoiceCubit>()
                                        .stopRecording();
                                  } else {
                                    context
                                        .read<AuraVoiceCubit>()
                                        .startRecording();
                                  }
                                },
                                onLongPress: () {
                                  if (!isRecording) {
                                    context
                                        .read<AuraVoiceCubit>()
                                        .startRecording();
                                  }
                                },
                              ),
                              SizedBox(height: heroGap),
                              _RecordPrompt(isRecording: isRecording),
                              const Spacer(),
                              _RecentRecordingsPanel(
                                state: state,
                                onSeeAll: () {
                                  final cubit = context.read<AuraVoiceCubit>();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const FullHistoryPage(),
                                    ),
                                  ).then((_) {
                                    cubit.resetToReady();
                                  });
                                },
                                onDelete: (path) {
                                  context.read<AuraVoiceCubit>().deleteAudio(
                                    path,
                                  );
                                },
                                onPlay: (path) {
                                  final cubit = context.read<AuraVoiceCubit>();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          PlaybackTemplatePage(audioPath: path),
                                    ),
                                  ).then((_) {
                                    cubit.resetToReady();
                                  });
                                },
                              ),
                              const SizedBox(height: 20),
                              const _HomeBottomNav(),
                              SizedBox(
                                height:
                                    MediaQuery.paddingOf(context).bottom + 12,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class _HomeBackground extends StatelessWidget {
  const _HomeBackground();

  static const gradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF101624), Color(0xFF080B14), Color(0xFF070912)],
    stops: [0, 0.48, 1],
  );

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(gradient: gradient),
      child: Stack(
        children: [
          Positioned(
            top: 96,
            left: -140,
            child: _GlowWash(
              size: 260,
              color: AppColors.neonPrimary.withValues(alpha: 0.12),
            ),
          ),
          Positioned(
            top: 172,
            right: -120,
            child: _GlowWash(
              size: 240,
              color: AppColors.neonSecondary.withValues(alpha: 0.13),
            ),
          ),
          Positioned(
            bottom: -90,
            left: 20,
            right: 20,
            child: _GlowWash(
              size: 320,
              color: AppColors.neonPrimary.withValues(alpha: 0.07),
            ),
          ),
        ],
      ),
    );
  }
}

class _GlowWash extends StatelessWidget {
  const _GlowWash({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: [color, color.withValues(alpha: 0)]),
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader({required this.onImportPressed});

  final VoidCallback onImportPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        RichText(
          text: const TextSpan(
            style: TextStyle(
              fontSize: 26,
              height: 1,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
            children: [
              TextSpan(text: 'Aura'),
              TextSpan(
                text: 'Voice',
                style: TextStyle(color: Color(0xFF6875FF)),
              ),
            ],
          ),
        ),
        const Spacer(),
        _HeaderAction(
          // Cupertino does not ship a crown icon; this is closest to the mockup.
          icon: Icons.workspace_premium_rounded,
          color: AppColors.warning,
          onPressed: onImportPressed,
        ),
      ],
    );
  }
}

class _HeaderAction extends StatelessWidget {
  const _HeaderAction({
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          width: 48,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: AppColors.glassSurfaceElevated,
            border: Border.all(color: AppColors.glassBorder),
          ),
          child: Icon(icon, color: color, size: 22),
        ),
      ),
    );
  }
}

class _RecordPrompt extends StatelessWidget {
  const _RecordPrompt({required this.isRecording});

  final bool isRecording;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          isRecording ? Icons.graphic_eq_rounded : Icons.keyboard_voice_rounded,
          color: isRecording ? AppColors.neonPrimary : AppColors.neonSecondary,
          size: 28,
        ),
        const SizedBox(height: 8),
        Text(
          isRecording ? 'Recording...' : 'Tap to Record',
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20,
            height: 1.15,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          isRecording ? 'tap again to stop' : 'or hold to record',
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
            height: 1.2,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _RecentRecordingsPanel extends StatelessWidget {
  const _RecentRecordingsPanel({
    required this.state,
    required this.onSeeAll,
    required this.onDelete,
    required this.onPlay,
  });

  final AuraVoiceState state;
  final VoidCallback onSeeAll;
  final ValueChanged<String> onDelete;
  final ValueChanged<String> onPlay;

  @override
  Widget build(BuildContext context) {
    final historyFiles = state is AuraVoiceReady
        ? (state as AuraVoiceReady).historyFiles
        : const <String>[];
    final displayCount = historyFiles.length > 3 ? 3 : historyFiles.length;

    return NeonGlassSurface(
      borderRadius: 20,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
      backgroundColor: const Color(0xB3141B2C),
      child: SizedBox(
        height: 278,
        child: Column(
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Recent Recordings',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 17,
                      height: 1.2,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                if (historyFiles.length > 3)
                  TextButton(
                    onPressed: onSeeAll,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      minimumSize: const Size(54, 36),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      'See All',
                      style: TextStyle(
                        color: Color(0xFF6576FF),
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 14),
            Container(height: 1, color: Colors.white.withValues(alpha: 0.08)),
            const SizedBox(height: 8),
            Expanded(child: _buildContent(context, historyFiles, displayCount)),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    List<String> historyFiles,
    int displayCount,
  ) {
    if (state is AuraVoiceRecording) {
      return const Center(
        child: Text(
          'Recording in progress',
          style: TextStyle(color: AppColors.textHint, fontSize: 14),
        ),
      );
    }

    if (historyFiles.isEmpty) {
      return const Center(
        child: Text(
          'No recordings yet.\nImport a file or start recording.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
            height: 1.35,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: displayCount,
      itemBuilder: (context, index) {
        final path = historyFiles[index];
        final file = File(path);
        final fileName = file.uri.pathSegments.last;
        final date = file.lastModifiedSync();
        final formattedDate = _formatRecentDate(date);
        const fallbackDuration = '00:24';

        return Dismissible(
          key: Key(path),
          direction: DismissDirection.endToStart,
          background: Container(
            margin: const EdgeInsets.symmetric(vertical: 3),
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.85),
              borderRadius: BorderRadius.circular(16),
            ),
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: const Icon(
              Icons.delete_outline_rounded,
              color: Colors.white,
            ),
          ),
          onDismissed: (_) => onDelete(path),
          child: RecordingListTile(
            title: fileName,
            subtitle: formattedDate,
            duration: fallbackDuration,
            onPlay: () => onPlay(path),
          ),
        );
      },
    );
  }

  String _formatRecentDate(DateTime date) {
    final now = DateTime.now();
    final isToday =
        now.year == date.year && now.month == date.month && now.day == date.day;
    final hour = date.hour == 0
        ? 12
        : date.hour > 12
        ? date.hour - 12
        : date.hour;
    final minute = date.minute.toString().padLeft(2, '0');
    final period = date.hour >= 12 ? 'PM' : 'AM';

    if (isToday) {
      return 'Today, $hour:$minute $period';
    }

    return '${date.day}/${date.month}/${date.year}, $hour:$minute $period';
  }
}

class _HomeBottomNav extends StatelessWidget {
  const _HomeBottomNav();

  @override
  Widget build(BuildContext context) {
    return const NeonGlassSurface(
      height: 76,
      borderRadius: 18,
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      backgroundColor: Color(0xCC172033),
      child: Row(
        children: [
          Expanded(
            child: _BottomNavItem(
              icon: Icons.home_rounded,
              label: 'Home',
              isActive: true,
            ),
          ),
          Expanded(
            child: _BottomNavItem(
              icon: Icons.graphic_eq_rounded,
              label: 'Tuner',
            ),
          ),
          Expanded(
            child: _BottomNavItem(
              icon: Icons.settings_outlined,
              label: 'Settings',
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  const _BottomNavItem({
    required this.icon,
    required this.label,
    this.isActive = false,
  });

  final IconData icon;
  final String label;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final color = isActive ? const Color(0xFF7282FF) : AppColors.textHint;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 30,
          height: 28,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: isActive
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.neonPrimary.withValues(alpha: 0.95),
                      AppColors.neonSecondary.withValues(alpha: 0.95),
                    ],
                  )
                : null,
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: AppColors.neonPrimary.withValues(alpha: 0.28),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : null,
          ),
          child: Icon(icon, color: isActive ? Colors.white : color, size: 22),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: isActive ? AppColors.textPrimary : AppColors.textSecondary,
            fontSize: 11,
            height: 1,
            fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
