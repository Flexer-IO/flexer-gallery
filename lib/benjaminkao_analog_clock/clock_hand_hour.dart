import 'package:flutter/material.dart';
import 'dart:math';

class HourHandPainter extends CustomPainter {
  final Paint hourHandPaint = Paint();
  final int hours;
  final int minutes;
  final Color color;

  HourHandPainter({
    required this.hours,
    required this.minutes,
    required this.color,
  }) {
    hourHandPaint.color = color;
    hourHandPaint.style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.width / 2; //Size = 244

    canvas.save();

    //Move canvas top left position to center of clock face
    canvas.translate(radius, radius);

    //Rotate canvas position to appropriate angle
    canvas.rotate(this.hours >= 12
        ? 2 * pi * ((this.hours - 12) / 12 + (this.minutes / 720))
        : 2 * pi * ((this.hours / 12) + (this.minutes / 720)));

    Path hourHand = Path();

    //    hourHand.lineTo(size.width, size.height);

    hourHand.moveTo(-5, 10);
    hourHand.lineTo(-5, - radius + radius / 3 + radius / 8);
    hourHand.lineTo(5, - radius + radius / 3 + radius / 8);
    hourHand.lineTo(5, 10);
    hourHand.close();

    canvas.drawPath(hourHand, hourHandPaint);
    canvas.drawShadow(hourHand, Colors.black, 7.0, false);

    canvas.restore();
  }

  //Need to repaint
  @override
  bool shouldRepaint(HourHandPainter oldDelegate) {
    return true;
  }
}