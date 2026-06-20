import 'package:flutter/material.dart';
import 'customizer.dart';

/// Minimal stub for the clock model to satisfy type requirements.
class ClockModel {}

/// Minimal stub for the SnakeClock widget to satisfy type requirements.
/// This placeholder extends [StatelessWidget] and accepts a [ClockModel].
/// The visual representation is a simple empty container to keep the UI
/// behavior neutral while allowing the code to compile.
class SnakeClock extends StatelessWidget {
  final ClockModel model;

  const SnakeClock(this.model, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Placeholder implementation; replace with actual clock UI as needed.
    return const SizedBox.shrink();
  }
}

class GildevSnakeclockPage extends StatelessWidget {
  const GildevSnakeclockPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Provide a builder that matches the expected ClockBuilder signature.
    final ClockBuilder builder = (BuildContext ctx, ClockModel model) => SnakeClock(model);
    return ClockCustomizer(builder);
  }
}