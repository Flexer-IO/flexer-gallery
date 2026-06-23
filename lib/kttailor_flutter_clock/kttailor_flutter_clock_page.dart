import 'package:flutter/material.dart';
import '../clock.dart';

class KttailorFlutterClockPage extends StatelessWidget {
  const KttailorFlutterClockPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Clock(),
    );
  }
}
