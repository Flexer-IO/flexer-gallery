import 'package:flutter/material.dart';
import '../../deps/analog_clock/lib/analog_clock.dart';

class ThealphamercFlutterAnalogClockPage extends StatelessWidget {
  const ThealphamercFlutterAnalogClockPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analog Clock'),
      ),
      body: Center(
        child: AnalogClock(),
      ),
    );
  }
}