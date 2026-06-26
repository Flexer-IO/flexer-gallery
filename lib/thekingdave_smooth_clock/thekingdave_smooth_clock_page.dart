import 'package:flutter/material.dart';
import '../clock.dart';
import '../visualization.dart';
import '../visu/SmoothClock.dart';

class ThekingdaveSmoothClockPage extends StatelessWidget {
  const ThekingdaveSmoothClockPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Settings for the clock visualization
    final ClockVisualizationSettings clockSettings =
        ClockVisualizationSettings(bgColor: Colors.black);

    // Create the SmoothClock visualization
    final Visualization visualization = Visualization(
      VisualizationSettings(
        name: 'Smooth Clock',
        refreshTime: const Duration(milliseconds: 100),
      ),
      SmoothClock(clockSettings),
    );

    // Return the clock wrapped in a Scaffold
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Clock(visualization),
      ),
    );
  }
}
