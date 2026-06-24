import 'package:flutter/material.dart';
import 'package:shehzaan_mansuri_animated_pandulum_clock/pendulum_clock.dart';

class ShehzaanMansuriAnimatedPandulumClockPage extends StatelessWidget {
  const ShehzaanMansuriAnimatedPandulumClockPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PendulumClock(),
    );
  }
}