import 'package:flutter/material.dart';
import 'customizer.dart';
import 'model.dart';
import 'solar_clock.dart';

class PolChenSolarclockPage extends StatelessWidget {
  const PolChenSolarclockPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ClockCustomizer(
        (ClockModel model) => SolarClock(model),
      ),
    );
  }
}