import 'package:flutter/material.dart';
import '../dash_clock.dart';

class ConstansFlutterClockPage extends StatelessWidget {
  const ConstansFlutterClockPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: DashClock(),
    );
  }
}
