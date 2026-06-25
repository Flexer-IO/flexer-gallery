import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/model.dart';
import '../digital_clock.dart';

class VolforFlutterClockPage extends StatelessWidget {
  const VolforFlutterClockPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: DigitalClock(ClockModel()),
      ),
    );
  }
}
