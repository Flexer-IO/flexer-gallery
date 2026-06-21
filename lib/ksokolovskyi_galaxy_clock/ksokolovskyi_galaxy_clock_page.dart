import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/model.dart';
import '../clock/galaxy_clock.dart';

class KsokolovskyiGalaxyClockPage extends StatelessWidget {
  const KsokolovskyiGalaxyClockPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Create a minimal ClockModel instance with default values.
    final model = ClockModel()
      ..weatherCondition = WeatherCondition.sunny;

    return Scaffold(
      body: GalaxyClock(model),
    );
  }
}
