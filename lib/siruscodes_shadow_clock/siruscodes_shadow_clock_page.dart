import 'package:flutter/material.dart';
import '../clock_parts/clock.dart';

class SiruscodesShadowClockPage extends StatelessWidget {
  const SiruscodesShadowClockPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Clock(customTheme: Theme.of(context)),
      ),
    );
  }
}
