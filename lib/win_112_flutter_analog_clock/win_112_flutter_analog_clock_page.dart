import 'package:flutter/material.dart';
import '../../deps/analog_clock/lib/analog_clock.dart';

class Win112FlutterAnalogClockPage extends StatelessWidget {
  const Win112FlutterAnalogClockPage({super.key});

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