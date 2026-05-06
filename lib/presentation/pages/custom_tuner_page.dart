import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/audio_filter_entity.dart';
import '../bloc/voice_tuner_cubit.dart';
import '../bloc/voice_tuner_state.dart';

class CustomTunerPage extends StatefulWidget {
  const CustomTunerPage({super.key});

  @override
  State<CustomTunerPage> createState() => _CustomTunerPageState();
}

class _CustomTunerPageState extends State<CustomTunerPage> {
  double _pitch = 1.0;
  double _speed = 1.0;

  @override
  void initState() {
    super.initState();
    final currentState = context.read<VoiceTunerCubit>().state;
    _pitch = currentState.currentFilter.pitch;
    _speed = currentState.currentFilter.speed;
  }

  void _applyCustomFilter() {
    context.read<VoiceTunerCubit>().applyCustomTune(_pitch, _speed);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0E), // US Market dark theme
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Advanced Tuner',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<VoiceTunerCubit, VoiceTunerState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                
                // Pitch Control
                _buildSliderCard(
                  title: "Pitch Shift",
                  value: _pitch,
                  min: 0.5,
                  max: 2.0,
                  icon: Icons.graphic_eq,
                  color: const Color(0xFF3B82F6),
                  onChanged: (val) {
                    setState(() => _pitch = val);
                    _applyCustomFilter();
                  },
                ),
                
                const SizedBox(height: 24),
                
                // Speed Control
                _buildSliderCard(
                  title: "Playback Speed",
                  value: _speed,
                  min: 0.5,
                  max: 2.0,
                  icon: Icons.speed,
                  color: const Color(0xFF8B5CF6),
                  onChanged: (val) {
                    setState(() => _speed = val);
                    _applyCustomFilter();
                  },
                ),
                
                const Spacer(),
                
                // Reset Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.05),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        _pitch = 1.0;
                        _speed = 1.0;
                      });
                      _applyCustomFilter();
                    },
                    child: const Text(
                      "Reset to Default",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSliderCard({
    required String title,
    required double value,
    required double min,
    required double max,
    required IconData icon,
    required Color color,
    required ValueChanged<double> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF161618),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              Text(
                value.toStringAsFixed(2) + "x",
                style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: color,
              inactiveTrackColor: Colors.white.withOpacity(0.1),
              thumbColor: Colors.white,
              overlayColor: color.withOpacity(0.2),
              trackHeight: 6,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
            ),
            child: Slider(
              value: value,
              min: min,
              max: max,
              onChanged: onChanged,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(min.toStringAsFixed(1), style: const TextStyle(color: Colors.white30, fontSize: 12)),
                Text(max.toStringAsFixed(1), style: const TextStyle(color: Colors.white30, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
