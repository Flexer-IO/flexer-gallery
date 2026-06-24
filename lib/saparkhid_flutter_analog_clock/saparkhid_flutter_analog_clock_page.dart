import 'package:flutter/material.dart';
import 'analog_clock.dart';

class SaparkhidFlutterAnalogClockPage extends StatelessWidget {
  const SaparkhidFlutterAnalogClockPage({super.key});

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