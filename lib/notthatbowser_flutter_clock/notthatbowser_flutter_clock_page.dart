import 'package:flutter/material.dart';
import '../components/the_clock.dart';

class NotthatbowserFlutterClockPage extends StatelessWidget {
  const NotthatbowserFlutterClockPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const TheClock(),
    );
  }
}
