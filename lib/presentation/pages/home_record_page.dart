import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart' as p;
import '../bloc/aura_voice_cubit.dart';
import '../bloc/aura_voice_state.dart';
import 'playback_template_page.dart';

class HomeRecordPage extends StatelessWidget {
  const HomeRecordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0E), // Very dark sleek background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'AuraVoice',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.drive_folder_upload, color: Colors.white70),
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
                content: Text(state.message, style: const TextStyle(color: Colors.white)),
                backgroundColor: Colors.redAccent.shade700,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            );
          } else if (state is AuraVoicePlayback) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => PlaybackTemplatePage(audioPath: state.filePath)),
            ).then((_) {
              context.read<AuraVoiceCubit>().resetToReady();
            });
          }
        },
        builder: (context, state) {
          if (state is AuraVoiceInitial) {
            return const Center(child: CircularProgressIndicator(color: Colors.white));
          }

          final isRecording = state is AuraVoiceRecording;
          
          return Column(
            children: [
              const SizedBox(height: 40),
              // Prominent Record Button Area
              Center(
                child: GestureDetector(
                  onTapDown: (_) => context.read<AuraVoiceCubit>().startRecording(),
                  onTapUp: (_) => context.read<AuraVoiceCubit>().stopRecording(),
                  onTapCancel: () => context.read<AuraVoiceCubit>().stopRecording(),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: isRecording ? 180 : 150,
                    height: isRecording ? 180 : 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: isRecording
                          ? LinearGradient(
                              colors: [Colors.redAccent.shade400, Colors.deepOrangeAccent],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : const LinearGradient(
                              colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                      boxShadow: [
                        BoxShadow(
                          color: isRecording 
                            ? Colors.redAccent.withOpacity(0.5) 
                            : const Color(0xFF3B82F6).withOpacity(0.3),
                          blurRadius: isRecording ? 40 : 20,
                          spreadRadius: isRecording ? 10 : 5,
                        )
                      ],
                    ),
                    child: Icon(
                      isRecording ? Icons.mic : Icons.mic_none,
                      color: Colors.white,
                      size: 60,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Text(
                isRecording ? "Recording... Release to process" : "Hold to record",
                style: TextStyle(
                  color: isRecording ? Colors.redAccent.shade100 : Colors.white54,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 50),
              
              // History Section
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color(0xFF161618),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.fromLTRB(30, 30, 30, 10),
                        child: Text(
                          "Recent Recordings",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Expanded(
                        child: _buildHistoryList(state, context),
                      ),
                    ],
                  ),
                ),
              ),
            ],
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
            style: TextStyle(color: Colors.white30, fontSize: 14),
          ),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        itemCount: state.historyFiles.length,
        itemBuilder: (context, index) {
          final path = state.historyFiles[index];
          final fileName = p.basename(path);
          final date = File(path).lastModifiedSync();
          final isExported = fileName.startsWith('AuraVoice_');
          
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.03),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.05)),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isExported ? Colors.greenAccent.withOpacity(0.1) : const Color(0xFF8B5CF6).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isExported ? Icons.check_circle : Icons.audiotrack,
                  color: isExported ? Colors.greenAccent : const Color(0xFF8B5CF6),
                ),
              ),
              title: Text(
                fileName,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 15),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                "${date.day}/${date.month}/${date.year} • ${date.hour}:${date.minute.toString().padLeft(2, '0')}",
                style: const TextStyle(color: Colors.white38, fontSize: 12),
              ),
              trailing: const Icon(Icons.chevron_right, color: Colors.white30),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => PlaybackTemplatePage(audioPath: path)),
                ).then((_) {
                  context.read<AuraVoiceCubit>().resetToReady();
                });
              },
            ),
          );
        },
      );
    }
    
    // When recording, show blurred/dimmed version
    return const Center(child: Text("Waiting...", style: TextStyle(color: Colors.white30)));
  }
}
