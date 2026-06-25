import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/customizer.dart';
import 'package:flutter_clock_helper/model.dart';

import '../origami_clock.dart';

class NitobesOrigamiflutterclockPage extends StatelessWidget {
  const NitobesOrigamiflutterclockPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ClockCustomizer(
        (ClockModel model) => OrigamiClock(model),
      ),
    );
  }
}
