import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/customizer.dart';
import 'analog_clock.dart';

class AhsanalidevFlutterClockPage extends StatelessWidget {
  const AhsanalidevFlutterClockPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ClockCustomizer((model) => AnalogClock(model));
  }
}
