import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:dots_clock/models/dots_clock_style.dart';
import 'package:dots_clock/widgets/dots_clock.dart';

class KainsteffenDotsClockPage extends StatelessWidget {
  const KainsteffenDotsClockPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ClockModel model = ClockModel();

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return DotsClock(
            model: model,
            style: DotsClockStyle.simplexNoise(),
            width: constraints.maxWidth,
            height: constraints.maxHeight,
          );
        },
      ),
    );
  }
}
