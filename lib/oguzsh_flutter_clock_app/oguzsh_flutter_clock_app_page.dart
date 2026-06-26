import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/customizer.dart';
import 'package:flutter_clock_helper/model.dart';

import '../digital_clock.dart';

class OguzshFlutterClockAppPage extends StatelessWidget {
  const OguzshFlutterClockAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ClockCustomizer((ClockModel model) => DigitalClock(model));
  }
}
