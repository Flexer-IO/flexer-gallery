import 'package:flutter/material.dart';
import 'customizer.dart';
import 'model.dart';

class HanielbaezNeonclockPage extends StatelessWidget {
  const HanielbaezNeonclockPage({super.key});

  static Widget _clockBuilder(ClockModel model) {
    // Minimal placeholder using the provided ClockModel.
    return const Center(
      child: Text(
        'Neon Clock',
        style: TextStyle(fontSize: 24),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClockCustomizer(_clockBuilder);
  }
}
