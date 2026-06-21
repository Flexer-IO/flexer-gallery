import 'clock.dart';
import '../constants/digits.dart';
import '../constants/tick_position.dart';
import 'package:flutter/material.dart';

class Digit extends StatelessWidget {
  final Digits digit;
  final Color baseColor;
  final Color tickColor;
  final double clockArea;
  final double? tickThickness;
  final bool flatStyle;
  final bool hideTick;
  final Curve curve;

  const Digit(
    this.digit, {
    required this.baseColor,
    this.clockArea = 100,
    this.tickThickness,
    this.tickColor = Colors.black87,
    this.curve = Curves.easeInOut,
    this.flatStyle = false,
    this.hideTick = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(mainAxisSize: MainAxisSize.min, children: [_buildClock(digit.topLeft), _buildClock(digit.topRight)]),
        Row(mainAxisSize: MainAxisSize.min, children: [_buildClock(digit.centerLeft), _buildClock(digit.centerRight)]),
        Row(mainAxisSize: MainAxisSize.min, children: [_buildClock(digit.bottomLeft), _buildClock(digit.bottomRight)]),
      ],
    );
  }

  Widget _buildClock(DoubleTickPosition position) => Clock(
        position,
        curve: curve,
        radius: clockArea,
        tickColor: tickColor,
        baseColor: baseColor,
        flatStyle: flatStyle,
        tickThickness: tickThickness,
        hideTick: hideTick,
      );
}