import 'package:flutter/material.dart';
import 'flip_clock_widget.dart';
import 'clock_theme.dart';

class AidevjoeFlipClockPage extends StatelessWidget {
  const AidevjoeFlipClockPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlipClockWidget(
        theme: ClockTheme.themes[0],
      ),
    );
  }
}