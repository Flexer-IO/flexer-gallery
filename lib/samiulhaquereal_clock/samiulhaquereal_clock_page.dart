import 'package:flutter/material.dart';
import 'clock_view.dart';

class SamiulhaquerealClockPage extends StatelessWidget {
  const SamiulhaquerealClockPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2D2F41),
      body: const Center(
        child: ClockView(),
      ),
    );
  }
}