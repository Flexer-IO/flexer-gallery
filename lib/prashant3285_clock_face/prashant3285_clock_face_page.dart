import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/customizer.dart';
import 'package:flutter_clock_helper/model.dart';
import '../digital_clock.dart';

class Prashant3285ClockFacePage extends StatelessWidget {
  const Prashant3285ClockFacePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ClockCustomizer((ClockModel model) => DigitalClock(model));
  }
}
