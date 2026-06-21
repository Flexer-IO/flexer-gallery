import 'package:flutter/material.dart';
import 'package:daniilbug_solar_system_clock/daniilbug_solar_system_clock/customizer.dart';
import 'package:daniilbug_solar_system_clock/daniilbug_solar_system_clock/solar_system_clock.dart';

class DaniilbugSolarSystemClockPage extends StatelessWidget {
  const DaniilbugSolarSystemClockPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ClockCustomizer(
      (ClockModel model) => SolarSystemClock(model),
    );
  }
}