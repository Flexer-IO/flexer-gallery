import 'package:flutter/material.dart';
import 'customizer.dart';
import 'model.dart';

class LtdangkhoaFlutterKaClockPage extends StatelessWidget {
  const LtdangkhoaFlutterKaClockPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ClockCustomizer(_builder);
  }

  static Widget _builder(ClockModel model) {
    // Minimal placeholder; the ClockCustomizer handles the UI.
    return const SizedBox.expand();
  }
}
