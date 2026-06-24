import 'package:flutter/material.dart';
import '../draw_driving.dart';

class YudetaDrivingClockPage extends StatelessWidget {
  const YudetaDrivingClockPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<DateTime>(
        stream: Stream<DateTime>.periodic(
          const Duration(milliseconds: 100),
          (_) => DateTime.now(),
        ),
        builder: (context, snapshot) {
          final dateTime = snapshot.data ?? DateTime.now();
          // The library defaults to 24‑hour format; you can adjust as needed.
          const is24HourFormat = true;
          return DrawnDriving(
            dateTime: dateTime,
            is24HourFormat: is24HourFormat,
          );
        },
      ),
    );
  }
}
