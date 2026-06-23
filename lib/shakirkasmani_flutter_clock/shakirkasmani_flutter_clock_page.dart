import 'package:flutter/material.dart';

/// Minimal stub for the clock model used by the original package.
class ClockModel {
  final bool is24HourFormat;
  const ClockModel({required this.is24HourFormat});
}

/// Signature for the builder function that receives a [ClockModel].
typedef ClockBuilder = Widget Function(ClockModel model);

/// Minimal stub for the customizer widget originally provided by
/// `flutter_clock_helper`. It simply creates a default [ClockModel] and
/// forwards it to the supplied builder.
class ClockCustomizer extends StatelessWidget {
  final ClockBuilder builder;
  const ClockCustomizer(this.builder, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const model = ClockModel(is24HourFormat: true);
    return builder(model);
  }
}

class ShakirkasmaniFlutterClockPage extends StatelessWidget {
  const ShakirkasmaniFlutterClockPage({super.key});

  Widget _clockBuilder(ClockModel model) {
    // Minimal placeholder using the model's data.
    return Center(
      child: Text(
        model.is24HourFormat ? '24‑hour Clock' : '12‑hour Clock',
        style: const TextStyle(fontSize: 24),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClockCustomizer(_clockBuilder);
  }
}