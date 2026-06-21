import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/customizer.dart';
import 'package:flutter_clock_helper/model.dart';

import '../fibonacci_clock.dart';

class Alameen688FlutterClockPage extends StatelessWidget {
  const Alameen688FlutterClockPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ClockCustomizer(
      (ClockModel model) => FibonacciClock(model),
    );
  }
}
