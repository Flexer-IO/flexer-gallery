import 'package:flutter/material.dart';
import 'clock.dart';

class WizpnaFlutterClockPage extends StatelessWidget {
  const WizpnaFlutterClockPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Clock(),
    );
  }
}