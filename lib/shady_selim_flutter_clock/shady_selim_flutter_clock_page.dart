import 'package:flutter/material.dart';
import '../analog_clock.dart';
import '../main.dart';

class ShadySelimFlutterClockPage extends StatelessWidget {
  const ShadySelimFlutterClockPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ClockCustomizer((model) => AnalogClock(model));
  }
}
