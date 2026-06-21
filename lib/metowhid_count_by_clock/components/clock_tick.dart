import '../constants/tick_position.dart';
import 'package:flutter/material.dart';

class ClockTick extends StatefulWidget {
  final Color color;
  final double length;
  final double? tickThickness;
  final SingleTickPosition tickPosition;
  final Curve curve;
  final bool hideTick;

  ClockTick({
    required this.length,
    this.tickThickness,
    this.tickPosition = SingleTickPosition.zero,
    this.color = Colors.black,
    this.curve = Curves.easeInOut,
    this.hideTick = false,
  });

  @override
  _ClockTickState createState() => _ClockTickState();
}

class _ClockTickState extends State<ClockTick> {
  @override
  Widget build(BuildContext context) {
    final thickness = widget.tickThickness ?? widget.length * .12;
    final tickDecoration = BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(thickness / 2)),
      color: widget.color,
    );
    final double tickLength = widget.length / 2 + thickness / 2;
    return TweenAnimationBuilder<double>(
      curve: widget.curve,
      tween: Tween<double>(begin: 0, end: widget.tickPosition.angleValue),
      duration: const Duration(milliseconds: 1000),
      builder: (BuildContext context, double value, Widget? child) => Transform.rotate(
        origin: Offset(0, -thickness / 2),
        alignment: Alignment.bottomCenter,
        angle: value,
        child: child!,
      ),
      child: AnimatedOpacity(
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 700),
        opacity: widget.tickPosition == SingleTickPosition.none && widget.hideTick ? 0 : 1,
        child: Container(
          width: thickness,
          height: tickLength,
          decoration: tickDecoration,
        ),
      ),
    );
  }
}