import 'package:flutter/material.dart';
import 'customizer.dart';
import 'model.dart';
import 'package:vmorilla_sunset_reflections_clock/sunset_reflections_clock.dart';

class VmorillaSunsetReflectionsClockPage extends StatelessWidget {
  const VmorillaSunsetReflectionsClockPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ClockCustomizer(
      (ClockModel model) => SunsetReflectionsClock(model),
    );
  }
}