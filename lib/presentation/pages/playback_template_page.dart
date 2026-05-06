import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart' as p;

import '../../domain/entities/audio_filter_entity.dart';
import '../bloc/voice_tuner_cubit.dart';
import '../bloc/voice_tuner_state.dart';
import '../widgets/fake_visualizer.dart';
import 'custom_tuner_page.dart';

class PlaybackTemplatePage extends StatefulWidget {
  final String audioPath;

  const PlaybackTemplatePage({super.key, required this.audioPath});

  @override
  State<PlaybackTemplatePage> createState() => _PlaybackTemplatePageState();
}

class _PlaybackTemplatePageState extends State<PlaybackTemplatePage> {
  @override
  void initState() {
    super.initState();
    // Langsung putar audio dengan filter normal saat halaman dibuka
    context.read<VoiceTunerCubit>().setAudioPath(widget.audioPath);
    context.read<VoiceTunerCubit>().play();
  }

  @override
  void dispose() {
    // Pastikan suara berhenti saat keluar halaman
    context.read<VoiceTunerCubit>().stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fileName = p.basename(widget.audioPath);

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0E), // Match home screen
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Tuner',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<VoiceTunerCubit, VoiceTunerState>(
        listener: (context, state) {
          if (state.exportMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.exportMessage!,
                  style: const TextStyle(color: Colors.white),
                ),
                backgroundColor: const Color(0xFF8B5CF6),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            );
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    // File Info Card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.03),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.white.withOpacity(0.05)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFF3B82F6).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(Icons.graphic_eq, color: Color(0xFF3B82F6)),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  fileName,
                                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Select a preset below to start modulating",
                                  style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),
                    // Visualizer Area
                    SizedBox(
                      height: 120,
                      child: Center(
                        child: FakeVisualizer(
                          isPlaying: state.isPlaying,
                          activeColor: const Color(0xFF8B5CF6),
                          inactiveColor: Colors.white.withOpacity(0.1),
                        ),
                      ),
                    ),

                    const Spacer(),

                    // Presets Grid
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF161618),
                        borderRadius: BorderRadius.circular(32),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Voice Presets",
                            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildPresetButton(
                                context,
                                state,
                                label: "Normal",
                                icon: Icons.face,
                                filter: AudioFilterEntity.normal(),
                              ),
                              _buildPresetButton(
                                context,
                                state,
                                label: "Chipmunk",
                                icon: Icons.child_care,
                                filter: AudioFilterEntity.chipmunk(),
                              ),
                              _buildPresetButton(
                                context,
                                state,
                                label: "Monster",
                                icon: Icons.smart_toy,
                                filter: AudioFilterEntity.monster(),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          // Custom Tuner Button
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: OutlinedButton.icon(
                              icon: const Icon(Icons.tune, color: Colors.white),
                              label: const Text(
                                "Advanced Tuner",
                                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: Colors.white.withOpacity(0.1)),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => const CustomTunerPage()),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Play / Stop Controls
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (state.isPlaying) {
                              context.read<VoiceTunerCubit>().stop();
                            } else {
                              context.read<VoiceTunerCubit>().play();
                            }
                          },
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF3B82F6).withOpacity(0.3),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                )
                              ],
                            ),
                            child: Icon(
                              state.isPlaying ? Icons.pause : Icons.play_arrow,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
              
              // Export / Save Button
              Positioned(
                top: 20,
                right: 20,
                child: state.isExporting
                  ? const CircularProgressIndicator(color: Color(0xFF8B5CF6))
                  : IconButton(
                      iconSize: 28,
                      color: state.exportMessage != null && state.exportMessage!.contains('Saved') 
                          ? Colors.greenAccent 
                          : Colors.white,
                      icon: Icon(
                        state.exportMessage != null && state.exportMessage!.contains('Saved')
                            ? Icons.check_circle
                            : Icons.download
                      ),
                      onPressed: state.exportMessage != null && state.exportMessage!.contains('Saved')
                          ? null // Disable if already saved
                          : () {
                              context.read<VoiceTunerCubit>().exportAudio();
                            },
                      tooltip: state.exportMessage != null && state.exportMessage!.contains('Saved')
                          ? 'Downloaded'
                          : 'Save Audio',
                    ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPresetButton(
    BuildContext context,
    VoiceTunerState state, {
    required String label,
    required IconData icon,
    required AudioFilterEntity filter,
  }) {
    final isSelected = state.currentFilter == filter;
    
    return GestureDetector(
      onTap: () {
        context.read<VoiceTunerCubit>().applyTemplate(filter);
      },
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF8B5CF6) : Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(20),
              boxShadow: isSelected
                  ? [BoxShadow(color: const Color(0xFF8B5CF6).withOpacity(0.4), blurRadius: 15, spreadRadius: 2)]
                  : [],
            ),
            child: Icon(icon, color: isSelected ? Colors.white : Colors.white54, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.white54,
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
