import 'package:flutter/material.dart';
import 'analogue_clock.dart';
import 'model.dart';

class IsatippensFlutterClockPage extends StatelessWidget {
  const IsatippensFlutterClockPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: AspectRatio(
            aspectRatio: 5 / 3,
            child: AnalogueClock(
              model: TemperatureModel(),
            ),
          ),
        ),
      ),
    );
  }
}
