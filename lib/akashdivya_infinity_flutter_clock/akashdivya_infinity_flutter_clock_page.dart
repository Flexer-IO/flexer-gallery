import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/customizer.dart';
import 'package:flutter_clock_helper/model.dart';

import '../analog_clock.dart';

class AkashdivyaInfinityFlutterClockPage extends StatelessWidget {
  const AkashdivyaInfinityFlutterClockPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ClockCustomizer(
        (ClockModel model) => AnalogClock(model),
      ),
    );
  }
}
