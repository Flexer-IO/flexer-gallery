import 'package:flutter/material.dart';
import 'customizer.dart';
import 'package:ciriousjoker_star_clock/star_clock.dart';

class CiriousjokerStarClockPage extends StatelessWidget {
  const CiriousjokerStarClockPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ClockCustomizer(
        (model) => StarClock(model),
      ),
    );
  }
}