import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/customizer.dart';
import 'package:flutter_clock_helper/model.dart';

import 'analog_clock.dart';

class AnkitmahadikFlutterclockPage extends StatelessWidget {
  const AnkitmahadikFlutterclockPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ClockCustomizer((ClockModel model) => AnalogClock(model));
  }
}
