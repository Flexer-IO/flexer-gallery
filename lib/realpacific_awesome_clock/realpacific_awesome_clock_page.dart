import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/model.dart';
import '../analog_clock.dart';

class RealpacificAwesomeClockPage extends StatelessWidget {
  const RealpacificAwesomeClockPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnalogClock(ClockModel()),
      ),
    );
  }
}
