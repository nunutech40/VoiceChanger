import 'dart:io';
import 'dart:isolate';
import 'dart:math';
import 'package:flutter/material.dart';

class FakeVisualizer extends StatefulWidget {
  final bool isPlaying;
  final Color activeColor;
  final Color inactiveColor;

  const FakeVisualizer({
    super.key, 
    required this.isPlaying,
    this.activeColor = Colors.greenAccent,
    this.inactiveColor = Colors.grey,
  });

  @override
  State<FakeVisualizer> createState() => _FakeVisualizerState();
}

class _FakeVisualizerState extends State<FakeVisualizer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  List<double> _levels = List.filled(30, 0.1);
  ReceivePort? _receivePort;
  Isolate? _isolate;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 100))..repeat();
    if (widget.isPlaying) {
      _startIsolate();
    }
  }

  @override
  void didUpdateWidget(FakeVisualizer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlaying && !oldWidget.isPlaying) {
      _startIsolate();
      _controller.repeat();
    } else if (!widget.isPlaying && oldWidget.isPlaying) {
      _stopIsolate();
      _controller.stop();
      setState(() {
        _levels = List.filled(30, 0.1);
      });
    }
  }

  void _startIsolate() async {
    _receivePort = ReceivePort();
    _isolate = await Isolate.spawn(_visualizerIsolateTask, _receivePort!.sendPort);
    _receivePort!.listen((message) {
      if (message is List<double> && mounted) {
        setState(() {
          _levels = message;
        });
      }
    });
  }

  void _stopIsolate() {
    _isolate?.kill(priority: Isolate.immediate);
    _isolate = null;
    _receivePort?.close();
    _receivePort = null;
  }

  static void _visualizerIsolateTask(SendPort sendPort) {
    // Isolate thread runs here, simulating "heavy" FFT calculation
    final random = Random();
    while (true) {
      // Simulate some heavy math loop so we can "flex" that it's off-main thread
      double dummy = 0;
      for(int i=0; i<10000; i++){ dummy += sin(i); }
      
      List<double> newLevels = List.generate(30, (_) => random.nextDouble());
      sendPort.send(newLevels);
      sleep(const Duration(milliseconds: 50)); // ~20 fps updates
    }
  }

  @override
  void dispose() {
    _stopIsolate();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: _levels.map((level) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 50),
          width: 8,
          height: 100 * level + 10,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            color: widget.isPlaying ? widget.activeColor : widget.inactiveColor,
            borderRadius: BorderRadius.circular(4),
            boxShadow: widget.isPlaying ? [
              BoxShadow(color: widget.activeColor, blurRadius: 10, spreadRadius: 1)
            ] : [],
          ),
        );
      }).toList(),
    );
  }
}
