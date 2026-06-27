import 'model.dart';

import 'analogue_clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const ClockApp());
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
}

class ClockApp extends StatelessWidget {
  const ClockApp({super.key});

  @override
  Widget build(BuildContext context) {
    final clock = AnalogueClock(
      model: TemperatureModel(),
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          primary: Color(0xFFBDBDBD),
        ),
        scaffoldBackgroundColor: Colors.white,
        primaryColor: Colors.grey.shade300,
      ),
      darkTheme: ThemeData.dark(),
      home: Scaffold(
        body: SafeArea(
          child: Center(
            child: AspectRatio(aspectRatio: 5 / 3, child: clock),
          ),
        ),
      ),
    );
  }
}
