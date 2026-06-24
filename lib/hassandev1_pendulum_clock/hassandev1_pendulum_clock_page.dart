import 'package:flutter/material.dart';
import 'package:hassandev1_pendulum_clock/pendulum_clock.dart';

class Hassandev1PendulumClockPage extends StatelessWidget {
  const Hassandev1PendulumClockPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pendulum Clock'),
        backgroundColor: Colors.deepOrange,
        centerTitle: true,
        elevation: 0,
      ),
      body: const PendulumClock(),
    );
  }
}