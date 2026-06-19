import 'package:flutter/material.dart';
import 'clocks/clock_face.dart';

class ShorebirdtechTimeShiftPage extends StatelessWidget {
  const ShorebirdtechTimeShiftPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ClockFace.generative.widget,
    );
  }
}