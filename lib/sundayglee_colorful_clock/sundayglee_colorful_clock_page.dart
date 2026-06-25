import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/customizer.dart';
import 'package:flutter_clock_helper/model.dart';
import '../colorful_clock.dart';

class SundaygleeColorfulClockPage extends StatelessWidget {
  const SundaygleeColorfulClockPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ClockCustomizer(
        (ClockModel model) => ColorfulClock(model),
      ),
    );
  }
}
