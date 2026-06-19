import 'package:flutter/material.dart';
import 'customizer.dart';
import 'model.dart';
import 'lava_clock.dart';

class JamesblascoFlutterLavaClockPage extends StatelessWidget {
  const JamesblascoFlutterLavaClockPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ClockCustomizer((ClockModel model) => LavaClock(model));
  }
}