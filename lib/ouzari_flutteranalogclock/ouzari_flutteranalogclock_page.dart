import 'package:flutter/material.dart';
import 'package:ouzari_flutteranalogclock/analog_clock.dart';

class OuzariFlutteranalogclockPage extends StatelessWidget {
  const OuzariFlutteranalogclockPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analog Clock'),
      ),
      body: Center(
        child: SizedBox(
          width: 300,
          height: 300,
          child: FlutterAnalogClock(
            width: 300,
            height: 300,
          ),
        ),
      ),
    );
  }
}