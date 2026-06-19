import 'package:flutter/material.dart';
import 'customizer.dart';
import 'model.dart';

class CookmscottFlutterclockchallengePage extends StatelessWidget {
  const CookmscottFlutterclockchallengePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ClockCustomizer(_buildClock);
  }

  Widget _buildClock(ClockModel model) => _SimpleClock(model);
}

class _SimpleClock extends StatelessWidget {
  const _SimpleClock(this.model, {Key? key}) : super(key: key);

  final ClockModel model;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Location: ${model.location}'),
          Text('Temperature: ${model.temperature}'),
          Text('High: ${model.high}  Low: ${model.low}'),
          Text('24‑hour format: ${model.is24HourFormat}'),
        ],
      ),
    );
  }
}