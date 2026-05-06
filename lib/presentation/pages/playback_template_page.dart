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
      backgroundColor: const Color(0xFFF9FAFB), // Match home screen light theme
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF1A1A1C), size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Tuner',
          style: TextStyle(
            color: Color(0xFF1A1A1C),
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<VoiceTunerCubit, VoiceTunerState>(
        builder: (context, state) {
          return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    // File Info Card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: const Color(0xFFF3F4F6)),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x05000000),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          )
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEFF6FF),
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
                                  style: const TextStyle(color: Color(0xFF1A1A1C), fontSize: 16, fontWeight: FontWeight.w600),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  "Select a preset below to start modulating",
                                  style: TextStyle(color: Color(0xFF8E8E93), fontSize: 13),
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
                          activeColor: const Color(0xFF3B82F6), // Bright blue
                          inactiveColor: const Color(0xFFE5E7EB), // Soft gray
                        ),
                      ),
                    ),

                    const Spacer(),

                    // Presets Grid
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(color: const Color(0xFFF3F4F6)),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x05000000),
                            blurRadius: 15,
                            offset: Offset(0, 8),
                          )
                        ]
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Voice Presets",
                            style: TextStyle(color: Color(0xFF1A1A1C), fontSize: 16, fontWeight: FontWeight.w600),
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
                          Builder(builder: (context) {
                            final isCustom = state.currentFilter != AudioFilterEntity.normal() &&
                                             state.currentFilter != AudioFilterEntity.chipmunk() &&
                                             state.currentFilter != AudioFilterEntity.monster();
                            
                            return SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: OutlinedButton.icon(
                                icon: Icon(
                                  isCustom ? Icons.tune : Icons.tune_outlined, 
                                  color: isCustom ? Colors.white : const Color(0xFF3B82F6)
                                ),
                                label: Text(
                                  isCustom ? "Custom Active" : "Advanced Tuner",
                                  style: TextStyle(
                                    color: isCustom ? Colors.white : const Color(0xFF3B82F6), 
                                    fontSize: 16, 
                                    fontWeight: FontWeight.w600
                                  ),
                                ),
                                style: OutlinedButton.styleFrom(
                                  side: isCustom 
                                      ? BorderSide.none 
                                      : const BorderSide(color: Color(0xFFBFDBFE), width: 1.5),
                                  backgroundColor: isCustom ? const Color(0xFF3B82F6) : const Color(0xFFEFF6FF),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                  elevation: isCustom ? 4 : 0,
                                  shadowColor: const Color(0x403B82F6),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => const CustomTunerPage()),
                                  );
                                },
                              ),
                            );
                          }),
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
                                colors: [Color(0xFF60A5FA), Color(0xFF3B82F6)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x403B82F6), // 25% opacity blue
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                  offset: Offset(0, 8),
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
              color: isSelected ? const Color(0xFF3B82F6) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? Colors.transparent : const Color(0xFFE5E7EB),
                width: 1.5,
              ),
              boxShadow: isSelected
                  ? const [BoxShadow(color: Color(0x403B82F6), blurRadius: 15, spreadRadius: 2, offset: Offset(0, 6))]
                  : [],
            ),
            child: Icon(icon, color: isSelected ? Colors.white : const Color(0xFF9CA3AF), size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? const Color(0xFF3B82F6) : const Color(0xFF6B7280),
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
