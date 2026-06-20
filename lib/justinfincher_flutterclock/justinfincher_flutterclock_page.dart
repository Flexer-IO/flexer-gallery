import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/customizer.dart';
import 'package:flutter_clock_helper/model.dart';
import 'conic_clock.dart';

class JustinfincherFlutterclockPage extends StatelessWidget {
  const JustinfincherFlutterclockPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ClockCustomizer((ClockModel model) => ConicClock(model));
  }
}
