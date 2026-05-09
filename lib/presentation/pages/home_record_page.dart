import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../ui/theme/app_colors.dart';
import '../../ui/theme/app_gradients.dart';
import '../../ui/widgets/common/neon_glass_card.dart';
import '../../ui/widgets/home/neon_mic_button.dart';
import '../../ui/widgets/home/recording_list_tile.dart';
import '../bloc/aura_voice_cubit.dart';
import '../bloc/aura_voice_state.dart';
import 'full_history_page.dart';
import 'playback_template_page.dart';

class HomeRecordPage extends StatelessWidget {
  const HomeRecordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDeep,
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'AuraVoice',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 24,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.drive_folder_upload,
              color: AppColors.neonPrimary,
            ),
            onPressed: () {
              context.read<AuraVoiceCubit>().pickExternalFile();
            },
            tooltip: 'Import Audio',
          ),
        ],
      ),
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
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          } else if (state is AuraVoicePlayback) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PlaybackTemplatePage(audioPath: state.filePath),
              ),
            ).then((_) {
              context.read<AuraVoiceCubit>().resetToReady();
            });
          }
        },
        builder: (context, state) {
          if (state is AuraVoiceInitial) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.neonPrimary),
            );
          }

          final isRecording = state is AuraVoiceRecording;

          return Container(
            decoration: BoxDecoration(gradient: AppGradients.backgroundLayered),
            child: Column(
              children: [
                const SizedBox(height: 40),
                // Hero Mic Button Area
                Center(
                  child: NeonMicButton(
                    size: 100,
                    isRecording: isRecording,
                    onPressed: () {
                      if (isRecording) {
                        context.read<AuraVoiceCubit>().stopRecording();
                      } else {
                        context.read<AuraVoiceCubit>().startRecording();
                      }
                    },
                    onLongPress: () {
                      context.read<AuraVoiceCubit>().startRecording();
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  isRecording ? "Recording..." : "Hold to record",
                  style: TextStyle(
                    color: isRecording
                        ? AppColors.neonPrimary
                        : AppColors.textSecondary,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 40),

                // History Section with Glass Effect
                Expanded(
                  child: NeonGlassSurface(
                    borderRadius: 32.0,
                    padding: EdgeInsets.zero,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Recent Recordings",
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              if (state is AuraVoiceReady &&
                                  state.historyFiles.length > 3)
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const FullHistoryPage(),
                                      ),
                                    ).then((_) {
                                      context
                                          .read<AuraVoiceCubit>()
                                          .resetToReady();
                                    });
                                  },
                                  child: const Text(
                                    "See All",
                                    style: TextStyle(
                                      color: AppColors.neonPrimary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        Expanded(child: _buildHistoryList(state, context)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHistoryList(AuraVoiceState state, BuildContext context) {
    if (state is AuraVoiceReady) {
      if (state.historyFiles.isEmpty) {
        return const Center(
          child: Text(
            "No recordings yet.\nImport a file or start recording.",
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
          ),
        );
      }

      // Limit to 3 items on home page
      final displayCount = state.historyFiles.length > 3
          ? 3
          : state.historyFiles.length;

      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        itemCount: displayCount,
        itemBuilder: (context, index) {
          final path = state.historyFiles[index];
          final fileName = File(path).uri.pathSegments.last;
          final date = File(path).lastModifiedSync();
          final formattedDate = "${date.day}/${date.month}/${date.year}";
          final formattedTime =
              "${date.hour}:${date.minute.toString().padLeft(2, '0')}";

          return Dismissible(
            key: Key(path),
            direction: DismissDirection.endToStart,
            background: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.error,
                borderRadius: BorderRadius.circular(16),
              ),
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Icon(Icons.delete_outline, color: Colors.white),
            ),
            onDismissed: (direction) {
              context.read<AuraVoiceCubit>().deleteAudio(path);
            },
            child: RecordingListTile(
              title: fileName,
              subtitle: "$formattedDate • $formattedTime",
              onPlay: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PlaybackTemplatePage(audioPath: path),
                  ),
                ).then((_) {
                  context.read<AuraVoiceCubit>().resetToReady();
                });
              },
              onMenu: () {
                // TODO: Show bottom sheet menu
              },
            ),
          );
        },
      );
    }

    // When recording, show dimmed state
    return const Center(
      child: Text("Processing...", style: TextStyle(color: AppColors.textHint)),
    );
  }
}
