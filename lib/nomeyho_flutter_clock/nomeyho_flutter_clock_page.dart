import 'package:flutter/material.dart';
import 'customizer.dart';
import 'model.dart';

class NomeyhoFlutterClockPage extends StatelessWidget {
  const NomeyhoFlutterClockPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ClockCustomizer(
        (ClockModel model) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Location: ${model.location}'),
                Text('Temperature: ${model.temperature}'),
                Text('24‑Hour Format: ${model.is24HourFormat}'),
              ],
            ),
          );
        },
      ),
    );
  }
}
