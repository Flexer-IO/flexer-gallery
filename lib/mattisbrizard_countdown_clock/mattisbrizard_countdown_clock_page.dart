import 'package:flutter/material.dart';
import 'countdown_clock.dart';

class MattisbrizardCountdownClockPage extends StatelessWidget {
  const MattisbrizardCountdownClockPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const CountdownClock(),
    );
  }
}