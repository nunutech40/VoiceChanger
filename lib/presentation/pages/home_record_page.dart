import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart' as p;
import '../bloc/aura_voice_cubit.dart';
import '../bloc/aura_voice_state.dart';
import 'playback_template_page.dart';
import 'full_history_page.dart';

class HomeRecordPage extends StatelessWidget {
  const HomeRecordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB), // Clean off-white background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'AuraVoice',
          style: TextStyle(
            color: Color(0xFF1A1A1C), // Dark text
            fontSize: 24,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.drive_folder_upload, color: Color(0xFF3B82F6)),
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
                    width: isRecording ? 160 : 140,
                    height: isRecording ? 160 : 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isRecording ? const Color(0xFF3B82F6) : Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: isRecording 
                            ? const Color(0xFF3B82F6).withOpacity(0.4) 
                            : const Color(0xFF8E8E93).withOpacity(0.15),
                          blurRadius: isRecording ? 30 : 20,
                          spreadRadius: isRecording ? 8 : 2,
                          offset: const Offset(0, 8),
                        )
                      ],
                    ),
                    child: Icon(
                      isRecording ? Icons.mic : Icons.mic_none,
                      color: isRecording ? Colors.white : const Color(0xFF3B82F6),
                      size: 50,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Text(
                isRecording ? "Recording... Release to process" : "Hold to record",
                style: TextStyle(
                  color: isRecording ? const Color(0xFF3B82F6) : const Color(0xFF8E8E93),
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
                    color: Colors.white, // Clean white history sheet
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x0A000000), // Very subtle top shadow
                        blurRadius: 20,
                        offset: Offset(0, -5),
                      )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30, 30, 30, 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Recent Recordings",
                              style: TextStyle(
                                color: Color(0xFF1A1A1C), // Dark text
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (state is AuraVoiceReady && state.historyFiles.length > 3)
                              TextButton(
                                onPressed: () {
                                  // Navigate to full history
                                  // For now, we can just push a new page that passes the state
                                  // Or a dedicated FullHistoryPage
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => const FullHistoryPage()),
                                  ).then((_) {
                                    context.read<AuraVoiceCubit>().resetToReady();
                                  });
                                },
                                child: const Text(
                                  "See All",
                                  style: TextStyle(color: Color(0xFF3B82F6), fontWeight: FontWeight.w600),
                                ),
                              ),
                          ],
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
            style: TextStyle(color: Color(0xFF8E8E93), fontSize: 14),
          ),
        );
      }

      // Limit to 3 items on home page
      final displayCount = state.historyFiles.length > 3 ? 3 : state.historyFiles.length;

      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        itemCount: displayCount,
        itemBuilder: (context, index) {
          final path = state.historyFiles[index];
          final fileName = p.basename(path);
          final date = File(path).lastModifiedSync();
          final isExported = fileName.startsWith('AuraVoice_');
          
          return Dismissible(
            key: Key(path),
            direction: DismissDirection.endToStart,
            background: Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFEF4444), // Red for delete
                borderRadius: BorderRadius.circular(20),
              ),
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Icon(Icons.delete_outline, color: Colors.white),
            ),
            onDismissed: (direction) {
              context.read<AuraVoiceCubit>().deleteAudio(path);
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFF3F4F6)), // Light gray border
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x05000000), // Extremely subtle shadow
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  )
                ]
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                leading: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isExported ? const Color(0xFFECFDF5) : const Color(0xFFEFF6FF), // Soft green or blue
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isExported ? Icons.check_circle_outline : Icons.audiotrack,
                    color: isExported ? const Color(0xFF10B981) : const Color(0xFF3B82F6), // Green or Blue icon
                  ),
                ),
                title: Text(
                  fileName,
                  style: const TextStyle(color: Color(0xFF1A1A1C), fontWeight: FontWeight.w600, fontSize: 15),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    "${date.day}/${date.month}/${date.year} • ${date.hour}:${date.minute.toString().padLeft(2, '0')}",
                    style: const TextStyle(color: Color(0xFF8E8E93), fontSize: 13),
                  ),
                ),
                trailing: const Icon(Icons.chevron_right, color: Color(0xFFD1D5DB)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => PlaybackTemplatePage(audioPath: path)),
                  ).then((_) {
                    context.read<AuraVoiceCubit>().resetToReady();
                  });
                },
              ),
            ),
          );
        },
      );
    }
    
    // When recording, show blurred/dimmed version
    return const Center(child: Text("Processing...", style: TextStyle(color: Color(0xFF8E8E93))));
  }
}
