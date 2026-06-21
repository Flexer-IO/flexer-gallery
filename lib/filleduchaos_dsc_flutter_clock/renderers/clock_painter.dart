import 'package:flutter/rendering.dart';

export './utils.dart';

abstract class ClockPainter extends CustomPainter {
  final num arcOffset;
  final Color color;

  ClockPainter({num? arcOffset, required this.color}) : arcOffset = arcOffset ?? 0;

  @override
  bool shouldRepaint(covariant ClockPainter other) =>
      arcOffset != other.arcOffset || color != other.color;
}