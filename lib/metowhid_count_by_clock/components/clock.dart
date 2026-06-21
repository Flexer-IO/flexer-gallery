import 'clock_tick.dart';
import '../constants/tick_position.dart';
import 'package:flutter/material.dart';

class Clock extends StatelessWidget {
  final DoubleTickPosition time;
  final Color? baseColor;
  final Color tickColor;
  final double radius;
  final double spacing;
  final double tickMargin;
  final double? tickThickness;
  final bool flatStyle;
  final bool hideTick;
  final Curve curve;

  const Clock(
    this.time, {
    this.baseColor,
    this.spacing = 4,
    this.radius = 100,
    this.tickMargin = 4,
    this.tickThickness,
    this.tickColor = Colors.black,
    this.curve = Curves.easeInOut,
    this.flatStyle = false,
    this.hideTick = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: radius,
      height: radius,
      margin: EdgeInsets.all(spacing),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: baseColor ?? Colors.grey[300],
        boxShadow: flatStyle
            ? []
            : [
                BoxShadow(
                    color: Colors.black.withOpacity(.5),
                    offset: Offset(2, 2),
                    blurRadius: 7,
                    spreadRadius: .5),
                BoxShadow(
                    color: Colors.white.withOpacity(.90),
                    offset: Offset(-2, -2),
                    blurRadius: 7,
                    spreadRadius: .5),
              ],
      ),
      child: Container(
        margin: EdgeInsets.all(tickMargin),
        alignment: Alignment.topCenter,
        child: Stack(
          children: <Widget>[
            ClockTick(
              length: radius - tickMargin - spacing,
              tickPosition: time.hp1,
              color: tickColor,
              tickThickness: tickThickness,
              curve: curve,
              hideTick: hideTick,
            ),
            ClockTick(
              length: radius - tickMargin - spacing,
              tickPosition: time.hp2,
              color: tickColor,
              tickThickness: tickThickness,
              curve: curve,
              hideTick: hideTick,
            ),
          ],
        ),
      ),
    );
  }
}