import 'time_countdown.dart';
import 'package:flutter/material.dart';

/// A clock that focuses on the remaining time instead of the elapsed time.
class CountdownClock extends StatelessWidget {
  const CountdownClock({
    super.key,
    required this.bgColor,
    required this.remainingColor,
    required this.elapsedColor,
    required this.highlightColor,
  });

  final Color bgColor;
  final Color remainingColor;
  final Color elapsedColor;
  final Color highlightColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: bgColor,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double diameter = constraints.maxHeight;
            final double stroke = diameter * 0.12;
            final double gap = constraints.maxHeight * 0.040;

            return Stack(
              children: <Widget>[
                TimeCountdown(
                  countdownType: CountdownType.hour,
                  diameter: diameter,
                  strokeWidth: stroke,
                  remainingColor: remainingColor,
                  elapsedColor: elapsedColor,
                  highlightColor: highlightColor,
                ),
                TimeCountdown(
                  countdownType: CountdownType.minute,
                  diameter: diameter - 2 * stroke - gap,
                  strokeWidth: stroke,
                  remainingColor: remainingColor,
                  elapsedColor: elapsedColor,
                  highlightColor: highlightColor,
                ),
                TimeCountdown(
                  countdownType: CountdownType.second,
                  diameter: diameter - 4 * stroke - 2 * gap,
                  strokeWidth: (diameter - 4 * stroke - 2 * gap) / 2,
                  remainingColor: remainingColor,
                  elapsedColor: elapsedColor,
                  highlightColor: highlightColor,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
