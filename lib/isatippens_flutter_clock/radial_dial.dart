import 'dart:math';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' show radians;

class RadialDial extends StatelessWidget {
  const RadialDial({
    Key? key,
    required this.length,
    this.value = 0,
    this.distance = 100,
    this.textSize = 50,
    this.useSeperators = false,
    this.divisor = 2,
    this.startAtZero = true,
    this.clockwise = true,
    this.color,
    this.child,
  }) : assert(divisor != 0),
       super(key: key);

  final num length;
  final num distance;
  final num textSize;
  final num value;
  final bool useSeperators;
  final num divisor;
  final bool startAtZero;
  final bool clockwise;
  final Color? color;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Stack(alignment: Alignment.center, children: _buildDialDigits(context)),
        child ?? Container(),
      ],
    );
  }

  List<Widget> _buildDialDigits(BuildContext context) {
    final result = <Widget>[];
    final angleDivisor = radians(360 / length);
    final extender = distance;
    final start = startAtZero ? 0 : 1;
    String digit;

    for (num i = start; i < length + start; i++) {
      if (i % divisor != 0 && useSeperators) {
        digit = '٠';
      } else {
        digit = i.toString();
      }

      final angle =
          i * angleDivisor -
          radians(360 * value / length) +
          (clockwise ? 3.14 : -3.14 / 2);
      final transform = Matrix4.identity();
      if (clockwise) {
        transform.translateByDouble(
          (sin(angle) * extender).toDouble(),
          (cos(angle) * extender).toDouble(),
          0.0,
          1.0,
        );
      } else {
        transform.translateByDouble(
          (cos(angle) * extender).toDouble(),
          (sin(angle) * extender).toDouble(),
          0.0,
          1.0,
        );
      }
      result.add(
        Container(
          margin: const EdgeInsets.all(8.0),
          transform: transform,
          child: Text(
            digit,
            style: TextStyle(fontSize: textSize.toDouble(), color: color),
          ),
        ),
      );
    }
    return result;
  }
}
