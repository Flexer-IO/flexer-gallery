import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/model.dart';

import 'analog_clock.dart';

class JhomlalaSmartClockPage extends StatelessWidget {
  const JhomlalaSmartClockPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnalogClock(ClockModel()),
    );
  }
}
