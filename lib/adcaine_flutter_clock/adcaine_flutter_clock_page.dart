import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/model.dart';
import '../dot_matrix_clock.dart';

class AdcaineFlutterClockPage extends StatelessWidget {
  const AdcaineFlutterClockPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ClockModelBuilder(
      builder: (BuildContext context, ClockModel model) {
        return DotMatrixClock(clockModel: model);
      },
    );
  }
}
