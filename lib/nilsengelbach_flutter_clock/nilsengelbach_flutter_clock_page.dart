import 'package:flutter/material.dart';
import 'customizer.dart';
import 'model.dart';

class NilsengelbachFlutterClockPage extends StatelessWidget {
  const NilsengelbachFlutterClockPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ClockCustomizer((ClockModel model) => const SizedBox.shrink());
  }
}
