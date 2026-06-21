import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/customizer.dart';

import 'block_clock.dart';

class ZesageFlutterClockPage extends StatelessWidget {
  const ZesageFlutterClockPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ClockCustomizer((model) => BlockClock(model));
  }
}
