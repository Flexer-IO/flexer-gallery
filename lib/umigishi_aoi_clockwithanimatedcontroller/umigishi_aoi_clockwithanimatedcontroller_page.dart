import 'package:flutter/material.dart';
import 'package:umigishi_aoi_clockwithanimatedcontroller/clock_with_animated_controller.dart';

class UmigishiAoiClockwithanimatedcontrollerPage extends StatelessWidget {
  const UmigishiAoiClockwithanimatedcontrollerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ClockWithAnimatedController(),
    );
  }
}