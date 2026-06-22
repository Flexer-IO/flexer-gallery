import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/customizer.dart';
import 'package:flutter_clock_helper/model.dart';

import '../constants/app_colors.dart';
import '../my_digital_clock.dart';
import '../path_builder.dart';
import '../squares_manager.dart';

class JesperbellenbaumFlutterclockPage extends StatelessWidget {
  const JesperbellenbaumFlutterclockPage({super.key});

  @override
  Widget build(BuildContext context) {
    final pathBuilder = PathBuilder();
    final squaresManager = SquaresManager();

    return ClockCustomizer(
      (ClockModel model) => LayoutBuilder(
        builder: (context, constraints) {
          return FutureBuilder<List<bool>>(
            future: Future.wait([
              pathBuilder.init(constraints),
              squaresManager.init(constraints),
            ]),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const SizedBox.expand();
              }
              return MyDigitalClock(
                model,
                pathBuilder,
                squaresManager,
                constraints,
              );
            },
          );
        },
      ),
    );
  }
}
