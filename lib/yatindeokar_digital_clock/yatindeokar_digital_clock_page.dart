import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/customizer.dart';
import 'package:flutter_clock_helper/model.dart';
import 'digital_clock.dart';

class YatindeokarDigitalClockPage extends StatelessWidget {
  const YatindeokarDigitalClockPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ClockCustomizer((ClockModel model) => DigitalClock(model)),
    );
  }
}
