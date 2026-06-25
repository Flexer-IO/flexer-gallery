import 'package:flutter/material.dart';
import 'customizer.dart';
import 'model.dart';

/// Thin wrapper page for the `sun_clock` library.
///
/// This page simply embeds the library's [ClockCustomizer] widget,
/// providing a minimal builder that displays the current [ClockModel] data.
class AlainuxSunClockPage extends StatelessWidget {
  const AlainuxSunClockPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ClockCustomizer(_sunClockBuilder),
    );
  }
}

/// Builder required by [ClockCustomizer].
///
/// It creates a simple view that reflects the values stored in [ClockModel].
Widget _sunClockBuilder(ClockModel model) => _SunClockView(model: model);

/// Minimal UI that shows the data from [ClockModel].
class _SunClockView extends StatelessWidget {
  const _SunClockView({required this.model});

  final ClockModel model;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Location: ${model.location}'),
          Text('Temperature: ${model.temperature}'),
          Text('High: ${model.high}'),
          Text('Low: ${model.low}'),
          Text('24‑hour format: ${model.is24HourFormat}'),
        ],
      ),
    );
  }
}