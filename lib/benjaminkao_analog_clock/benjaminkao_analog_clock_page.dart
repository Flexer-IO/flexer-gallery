import 'package:flutter/material.dart';
import 'clock_body.dart';

class BenjaminkaoAnalogClockPage extends StatelessWidget {
  const BenjaminkaoAnalogClockPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ClockBody(),
      ),
    );
  }
}