import 'package:flutter/material.dart';
import '../customizer.dart';
import '../clocks/clock_scaffolding.dart';

class AhammerAdamsClockPage extends StatelessWidget {
  const AhammerAdamsClockPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ClockCustomizer(
      (model) => ClockScaffolding(model: model),
    );
  }
}
