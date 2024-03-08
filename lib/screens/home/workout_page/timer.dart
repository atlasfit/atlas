import 'dart:async';
import 'package:flutter/material.dart';

class TimerWidget extends StatefulWidget {
  const TimerWidget({super.key});

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  late Timer _timer;
  int _currentSeconds = 0;
  bool _isPaused = false;

  @override
  void initState() {
    super.initState();
    _currentSeconds = 0; // Change here to start from zero
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isPaused) {
        setState(() {
          _currentSeconds++; // Change here to count up
        });
      }
    });
  }

  void _pauseResumeTimer() {
    setState(() {
      _isPaused = !_isPaused;
    });
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    String formattedMinutes = minutes.toString().padLeft(2, '0');
    String formattedSeconds = remainingSeconds.toString().padLeft(2, '0');
    return '$formattedMinutes:$formattedSeconds';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pauseResumeTimer,
      child: Center(
        child: Text(
          _formatTime(_currentSeconds),
          style: TextStyle(
            fontSize: 48,
            color: _isPaused ? Colors.red : Colors.white,
          ),
        ),
      ),
    );
  }
}
