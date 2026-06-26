import 'package:flutter/material.dart';
import 'package:kmeoung_flutter_flip_clock/flip_clock.dart';

class KmeoungFlutterFlipClockPage extends StatelessWidget {
  const KmeoungFlutterFlipClockPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlipClock(),
    );
  }
}