import 'package:flutter/material.dart';
import '../core/agent/main_agent.dart';

class YerkbnAntClockPage extends StatelessWidget {
  const YerkbnAntClockPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: MainAgent().build(),
      ),
    );
  }
}
