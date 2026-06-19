import 'package:flutter/material.dart';
import 'clock.dart';

class NpkompleetClockPage extends StatelessWidget {
  const NpkompleetClockPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Clock(),
      ),
    );
  }
}