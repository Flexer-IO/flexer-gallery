import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/customizer.dart';
import '../analog_clock.dart';

class TsinisFlutterClockPage extends StatelessWidget {
  const TsinisFlutterClockPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ClockCustomizer(AnalogClock.new);
  }
}
