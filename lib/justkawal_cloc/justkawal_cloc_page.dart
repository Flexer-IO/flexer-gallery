import 'package:flutter/material.dart';
import 'digital_clock_maker.dart';

class JustkawalClocPage extends StatelessWidget {
  const JustkawalClocPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const DigitalClockMaker(
        blackMin: 37.0,
        blueMin: 37.0,
        freeBlack: 0,
        freeBlue: 0,
        primaryColor: Colors.black,
        accentColor: Colors.blue,
        highlightColor: Colors.white,
      ),
    );
  }
}
