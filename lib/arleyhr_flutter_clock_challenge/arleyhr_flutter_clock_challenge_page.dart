import 'package:flutter/material.dart';

import 'customizer.dart';
import 'model.dart';

class ArleyhrFlutterClockChallengePage extends StatelessWidget {
  const ArleyhrFlutterClockChallengePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ClockCustomizer(_clockBuilder);
  }

  static Widget _clockBuilder(ClockModel model) {
    // Simple placeholder that displays a few model values.
    return Center(
      child: Text(
        '24‑Hour: ${model.is24HourFormat}\n'
        'Location: ${model.location}\n'
        'Temp: ${model.temperature}',
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 18),
      ),
    );
  }
}
