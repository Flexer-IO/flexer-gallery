import 'package:flutter/material.dart';
import 'dart:math';

class TickerPainter extends CustomPainter {
  final DateTime datetime;
  final bool showTicks;
  final Color tickColor;

  static const double _baseSize = 320.0;

  const TickerPainter({
    required this.datetime,
    this.showTicks = true,
    this.tickColor = Colors.black,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final scaleFactor = size.shortestSide / _baseSize;
    if (showTicks) _paintTickMarks(canvas, size, scaleFactor);
  }

  void _paintTickMarks(Canvas canvas, Size size, double scaleFactor) {
    final r = size.shortestSide / 2;
    final tick = 10 * scaleFactor;
    final longTick = 20 * scaleFactor;
    final p = longTick + 4 * scaleFactor;
    final tickPaint = Paint()
      ..color = tickColor
      ..strokeWidth = 2.0 * scaleFactor;

    for (double i = 1; i <= 60; i += 0.5) {
      double len = 0;
      if (i % 5 == 0) {
        len = longTick;
      } else if (i % 2.5 == 0) {
        len = tick;
      }
      final angleFrom12 = i / 60.0 * 2.0 * pi;
      final angleFrom3 = pi / 2.0 - angleFrom12;

      canvas.drawLine(
        size.center(Offset(cos(angleFrom3) * (r + len - p), sin(angleFrom3) * (r + len - p))),
        size.center(Offset(cos(angleFrom3) * (r - p), sin(angleFrom3) * (r - p))),
        tickPaint,
      );
    }
  }

  @override
  bool shouldRepaint(TickerPainter oldDelegate) {
    return oldDelegate.datetime.isBefore(datetime);
  }
}
