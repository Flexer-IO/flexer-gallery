import 'package:flutter/material.dart';
import '../../deps/flutter_clock_helper/model.dart';
import 'digital_clock.dart';

class FabianSteinFlutterclockPage extends StatelessWidget {
  const FabianSteinFlutterclockPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DigitalClock(ClockModel()),
    );
  }
}