import 'package:flutter/material.dart';
import 'clock/clock_view.dart';

class AmndalsrAnalogclockFlutterPage extends StatelessWidget {
  const AmndalsrAnalogclockFlutterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ClockView(),
      ),
    );
  }
}