import 'package:flutter/material.dart';
import 'clock_animation.dart';

class RenuvkelkarClockAnimationPage extends StatelessWidget {
  const RenuvkelkarClockAnimationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ClockAnimation(),
    );
  }
}