import 'package:flutter/material.dart';
import 'customizer.dart';
import 'model.dart';

class AdarshMohantyNeumorphClockFlutterclockchallengePage extends StatelessWidget {
  const AdarshMohantyNeumorphClockFlutterclockchallengePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ClockCustomizer((ClockModel model) => const SizedBox.shrink());
  }
}
