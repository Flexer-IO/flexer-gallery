import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/customizer.dart';
import 'package:flutter_clock_helper/model.dart';
import '../analog_clock.dart';

class ChhannanFlutterClockChallengePage extends StatelessWidget {
  const ChhannanFlutterClockChallengePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ClockCustomizer(_builder);
  }

  static Widget _builder(ClockModel model) => AnalogClock(model);
}
