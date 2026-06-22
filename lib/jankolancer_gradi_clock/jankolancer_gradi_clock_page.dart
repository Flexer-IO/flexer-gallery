import 'package:flutter/material.dart';
import 'customizer.dart';
import 'model.dart';

class JankolancerGradiClockPage extends StatelessWidget {
  const JankolancerGradiClockPage({super.key});

  static Widget _clockBuilder(ClockModel model) {
    // Minimal placeholder using the model's data.
    return Center(
      child: Text(
        model.is24HourFormat ? '24‑hour format' : '12‑hour format',
        style: const TextStyle(fontSize: 24),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClockCustomizer(_clockBuilder);
  }
}