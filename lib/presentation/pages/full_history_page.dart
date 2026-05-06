import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart' as p;
import '../bloc/aura_voice_cubit.dart';
import '../bloc/aura_voice_state.dart';
import 'playback_template_page.dart';

class FullHistoryPage extends StatelessWidget {
  const FullHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF1A1A1C), size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'All Recordings',
          style: TextStyle(
            color: Color(0xFF1A1A1C),
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<AuraVoiceCubit, AuraVoiceState>(
        builder: (context, state) {
          if (state is AuraVoiceReady) {
            if (state.historyFiles.isEmpty) {
              return const Center(
                child: Text(
                  "No recordings yet.",
                  style: TextStyle(color: Color(0xFF8E8E93), fontSize: 14),
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
                
                return Dismissible(
                  key: Key(path),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEF4444),
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
                      border: Border.all(color: const Color(0xFFF3F4F6)),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x05000000),
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
                          color: isExported ? const Color(0xFFECFDF5) : const Color(0xFFEFF6FF),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isExported ? Icons.check_circle_outline : Icons.audiotrack,
                          color: isExported ? const Color(0xFF10B981) : const Color(0xFF3B82F6),
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
                        );
                      },
                    ),
                  ),
                );
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
