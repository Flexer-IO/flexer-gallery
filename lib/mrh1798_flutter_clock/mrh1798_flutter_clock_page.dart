import 'package:flutter/material.dart';
import 'customizer.dart';
import 'model.dart';

class Mrh1798FlutterClockPage extends StatelessWidget {
  const Mrh1798FlutterClockPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ClockCustomizer(_clockBuilder);
  }

  static Widget _clockBuilder(ClockModel model) => const SizedBox.shrink();
}
