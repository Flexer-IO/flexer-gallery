import 'package:flutter/material.dart';

import 'star.dart';

class DrawnStar extends Star {
  const DrawnStar({
    super.key,
    required this.color,
    required super.radius,
    required super.center,
  });

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox.expand(
        child: CustomPaint(
          painter: _StarPainter(
            color: color,
            radius: radius,
            center: center,
          ),
        ),
      ),
    );
  }
}

class _StarPainter extends CustomPainter {
  _StarPainter({
    required this.color,
    required this.radius,
    required this.center,
  });

  final Color color;
  final double radius;
  final Offset center;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(center, radius, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_StarPainter old) => old.color != color;
}
