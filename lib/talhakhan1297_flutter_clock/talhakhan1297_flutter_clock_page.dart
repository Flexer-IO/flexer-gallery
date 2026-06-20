import 'package:flutter/material.dart';
import 'customizer.dart';
import 'model.dart';

class Talhakhan1297FlutterClockPage extends StatelessWidget {
  const Talhakhan1297FlutterClockPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ClockCustomizer(
      (ClockModel model) => const SizedBox.shrink(),
    );
  }
}
