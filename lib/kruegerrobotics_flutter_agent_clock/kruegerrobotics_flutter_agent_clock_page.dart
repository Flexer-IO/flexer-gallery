import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/model.dart';
import 'agent_clock.dart';

class KruegerroboticsFlutterAgentClockPage extends StatelessWidget {
  const KruegerroboticsFlutterAgentClockPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ClockModelBuilder(
      builder: (context, model) => AnalogClock(model),
    );
  }
}
