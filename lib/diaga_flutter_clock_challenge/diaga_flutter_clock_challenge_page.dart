import 'package:flutter/material.dart';
import '../digital_clock.dart';

class DiagaFlutterClockChallengePage extends StatelessWidget {
  const DiagaFlutterClockChallengePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: DigitalClock(),
      ),
    );
  }
}
