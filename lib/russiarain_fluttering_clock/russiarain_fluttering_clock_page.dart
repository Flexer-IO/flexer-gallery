import 'package:flutter/material.dart';

import 'customizer.dart';
import 'model.dart';

class RussiarainFlutteringClockPage extends StatelessWidget {
  const RussiarainFlutteringClockPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ClockCustomizer(_clockBuilder);
  }

  static Widget _clockBuilder(ClockModel model) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Location: ${model.location}'),
          Text('Temperature: ${model.temperature}'),
          Text('24‑hour format: ${model.is24HourFormat}'),
        ],
      ),
    );
  }
}