import 'package:flutter/material.dart';

import '../constants.dart';

class SnakePainter extends CustomPainter {
  DateTime time;
  final colors;

  double headX = 0;
  double headY = 0;

  SnakePainter(this.time, this.colors);

  void drawTongue(Canvas canvas, double snakeThickness, double direction) {
    var paint = Paint()..color = colors[Entity.tongue];
    double length = time.second.isEven ? snakeThickness : snakeThickness * 1.3;

    Path tongue = Path();
    tongue.moveTo(headX, headY - snakeThickness / 6);
    tongue.relativeLineTo(length * direction, 0);
    tongue.relativeLineTo(-5 * direction, snakeThickness / 6);
    tongue.relativeLineTo(5 * direction, snakeThickness / 6);
    tongue.relativeLineTo(-length * direction, 0);
    tongue.close();

    canvas.drawPath(tongue, paint);
  }

  void drawApple(
    Canvas canvas,
    Color color,
    double snakeThickness,
    double x,
    double y,
  ) {
    double radius = snakeThickness * 0.6;
    canvas.drawCircle(Offset(x, y), radius, Paint()..color = color);
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPaint(Paint()..color = colors[Entity.background]);

    int nbHoursToDraw = (time.hour >= 12) ? time.hour - 12 : time.hour;
    double snakeStartPosY = size.height / 9;
    double snakeIntervalY = (size.height - 2 * snakeStartPosY) / 11;
    double snakeThickness = snakeIntervalY / 1.25;
    double snakeStartPosX = size.width / 10;
    double snakeEndPosX = size.width / 10 * 9;
    double snakeWidth = snakeEndPosX - snakeStartPosX;
    headY = snakeStartPosY + nbHoursToDraw * snakeIntervalY;
    var paint = Paint()
      ..strokeCap = StrokeCap.round
      ..strokeWidth = snakeThickness
      ..color = colors[Entity.body];

    if (time.hour < 12) {
      if (time.hour < 9 || time.hour == 9 && time.minute < 29) {
        drawApple(
          canvas,
          appleColors[Apple.yellow]!,
          snakeThickness,
          snakeStartPosX + snakeWidth * 30 / 60,
          snakeStartPosY + snakeIntervalY * 9,
        );
      }
    } else {
      if (time.hour < 13 || time.hour == 13 && time.minute < 29) {
        drawApple(
          canvas,
          appleColors[Apple.red]!,
          snakeThickness,
          snakeStartPosX + snakeWidth * 30 / 60,
          snakeStartPosY + snakeIntervalY * 1,
        );
      }
      if (time.hour < 19 || time.hour == 19 && time.minute < 29) {
        drawApple(
          canvas,
          appleColors[Apple.green]!,
          snakeThickness,
          snakeStartPosX + snakeWidth * 30 / 60,
          snakeStartPosY + snakeIntervalY * 7,
        );
      }
    }

    if (time.hour >= 12) {
      canvas.drawLine(
        Offset(snakeStartPosX, 0),
        Offset(snakeStartPosX, snakeStartPosY),
        paint,
      );
    }

    for (var hours = 0; hours < nbHoursToDraw; hours++) {
      canvas.drawLine(
        Offset(snakeStartPosX, snakeStartPosY + hours * snakeIntervalY),
        Offset(snakeEndPosX, snakeStartPosY + hours * snakeIntervalY),
        paint,
      );
      if (hours.isOdd) {
        canvas.drawLine(
          Offset(snakeStartPosX, snakeStartPosY + hours * snakeIntervalY),
          Offset(
            snakeStartPosX,
            snakeStartPosY + hours * snakeIntervalY + snakeIntervalY,
          ),
          paint,
        );
      } else {
        canvas.drawLine(
          Offset(snakeEndPosX, snakeStartPosY + hours * snakeIntervalY),
          Offset(
            snakeEndPosX,
            snakeStartPosY + hours * snakeIntervalY + snakeIntervalY,
          ),
          paint,
        );
      }
    }

    if (nbHoursToDraw.isEven) {
      headX =
          snakeStartPosX +
          (snakeWidth * time.minute / 60 +
              (snakeWidth / 60 * time.second / 60));
      drawTongue(canvas, snakeThickness, 1);
      canvas.drawLine(
        Offset(snakeStartPosX, headY),
        Offset(headX, headY),
        paint,
      );

      paint.color = colors[Entity.eyes];
      paint.strokeWidth = 1;

      if ((time.second % blinkInterval) == 0) {
        canvas.drawLine(
          Offset(headX + 1, headY - snakeThickness / 3),
          Offset(headX + 1, headY - 1),
          paint,
        );
        canvas.drawLine(
          Offset(headX + 1, headY + snakeThickness / 3),
          Offset(headX + 1, headY + 1),
          paint,
        );
      } else {
        canvas.drawOval(
          Rect.fromLTRB(
            headX - snakeThickness / 4,
            headY - snakeThickness / 3,
            headX + snakeThickness / 3,
            headY - 1,
          ),
          paint,
        );
        canvas.drawOval(
          Rect.fromLTRB(
            headX - snakeThickness / 4,
            headY + snakeThickness / 3,
            headX + snakeThickness / 3,
            headY + 1,
          ),
          paint,
        );
      }
    } else {
      headX =
          snakeEndPosX -
          (snakeWidth * time.minute / 60 +
              (snakeWidth / 60 * time.second / 60));
      drawTongue(canvas, snakeThickness, -1);
      canvas.drawLine(Offset(snakeEndPosX, headY), Offset(headX, headY), paint);

      paint.color = colors[Entity.eyes];
      paint.strokeWidth = 1;

      if ((time.second % blinkInterval) == 0) {
        canvas.drawLine(
          Offset(headX - 1, headY - snakeThickness / 3),
          Offset(headX - 1, headY - 1),
          paint,
        );
        canvas.drawLine(
          Offset(headX - 1, headY + snakeThickness / 3),
          Offset(headX - 1, headY + 1),
          paint,
        );
      } else {
        canvas.drawOval(
          Rect.fromLTRB(
            headX + snakeThickness / 4,
            headY - snakeThickness / 3,
            headX - snakeThickness / 3,
            headY - 1,
          ),
          paint,
        );
        canvas.drawOval(
          Rect.fromLTRB(
            headX + snakeThickness / 4,
            headY + snakeThickness / 3,
            headX - snakeThickness / 3,
            headY + 1,
          ),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(SnakePainter oldDelegate) =>
      oldDelegate.time.second != time.second || oldDelegate.colors != colors;
}
