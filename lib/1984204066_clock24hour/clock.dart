import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class ClockPage extends StatefulWidget {
  final Color? hourHandColor;
  final Color? minuteHandColor;
  final Color? secondHandColor;
  final Color? numberColor;
  final Color? borderColor;

  const ClockPage(
      {Key? key,
        this.hourHandColor,
        this.minuteHandColor,
        this.secondHandColor,
        this.numberColor,
        this.borderColor})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ClockPageState();
  }
}

class ClockPageState extends State<ClockPage> {
  late Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        // Rebuild to update the clock.
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);
    final wPixel = queryData.size.width; // * queryData.devicePixelRatio;
    final wBar = queryData.padding.top;
    double radius = 210;
    if (wPixel < radius * 2 + wBar) radius = (wPixel - wBar) / 2;
    return Container(
        height: wPixel,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0), // 圆角度
            image: const DecorationImage(
                image: AssetImage(
                  'assets/skeleton.png',
                ),
                fit: BoxFit.fill)),
        child: CustomPaint(
            painter: ClockPainter(radius,
                numberColor: Colors.blue,
                handColor: Colors.black,
                borderColor: Colors.black),
            size: Size(radius * 2, radius * 2)));
  }
}

class ClockPainter extends CustomPainter {
  final DateTime datetime = DateTime.now();
  final Color handColor;
  final Color numberColor;
  final Color borderColor;
  final double radius;
  final double scale;
  final double borderWidth;

  List<Offset> secondsOffset = [];
  late TextPainter textPainter;

  ClockPainter(this.radius,
      {this.handColor = Colors.black,
        this.numberColor = Colors.black,
        this.borderColor = Colors.black})
      : scale = radius / 250,
        borderWidth = radius / 25 {
    final double secondDistance = radius - borderWidth * 2;
    // init seconds offset
    for (var i = 0; i < 120; i++) {
      Offset offset = Offset(
          cos(degToRad(3 * i - 90)) * secondDistance + radius,
          sin(degToRad(3 * i - 90)) * secondDistance + radius);
      secondsOffset.add(offset);
    }

    textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.rtl,
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    // draw border
    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;
    canvas.drawCircle(
        Offset(radius, radius), radius - borderWidth / 2, borderPaint);

    // draw second points
    final double distance = drawPointsText(canvas);
    drawHands(canvas);

    canvas.save();
    canvas.translate(radius, radius);
    {
      final double crossDistance = drawCross(canvas, distance);
      drawJ33(canvas, crossDistance);
    }
    canvas.restore();
  }

  double drawPointsText(Canvas canvas) {
    final secondPPaint = Paint()
      ..strokeWidth = 2 * scale
      ..color = numberColor;
    assert(secondsOffset.isNotEmpty);
    canvas.drawPoints(PointMode.points, secondsOffset, secondPPaint);

    canvas.save();
    canvas.translate(radius, radius);

    final double angle = degToRad(180 / 60);
    final double dRadius = radius - borderWidth * 4;
    List<Offset> bigger = [];
    for (var i = 0; i < secondsOffset.length; i++) {
      if (i % 5 == 0) {
        int h24 = i ~/ 5;
        bigger.add(secondsOffset[i]);
        // draw number
        canvas.save();
        canvas.translate(0.0, -dRadius);
        textPainter.text = TextSpan(
          text: "${h24 == 0 ? 12 : h24 == 12 ? 24 : h24 > 12 ? h24 - 12 : h24}",
          style: TextStyle(
            color: numberColor,
            fontFamily: 'Times New Roman',
            fontSize: 28.0 * scale,
          ),
        );

        // helps make the text painted vertically
        canvas.rotate(-angle * i);

        textPainter.layout();
        textPainter.paint(
            canvas, Offset(-(textPainter.width / 2), -(textPainter.height / 2)));
        canvas.restore();
      }
      canvas.rotate(angle);
    }
    canvas.restore();

    var biggerPaint = Paint()
      ..strokeWidth = 5 * scale
      ..color = numberColor;
    canvas.drawPoints(PointMode.points, bigger, biggerPaint);
    biggerPaint.strokeWidth = 7 * scale;
    canvas.drawPoints(PointMode.points, [bigger[0]],
        biggerPaint..color = Colors.red);
    canvas.drawPoints(PointMode.points, [bigger[12]],
        biggerPaint..color = Colors.greenAccent);

    final double digitDistance = radius - borderWidth * 4 - textPainter.height / 2;
    return digitDistance;
  }

  void drawHands(Canvas canvas) {
    final DateTime datetime = DateTime.now();
    final int hour = datetime.hour;
    final int minute = hour.isEven ? datetime.minute + 60 : datetime.minute;
    final int second = minute.isEven ? datetime.second + 60 : datetime.second;
    double startPscale = radius * 0.2;
    double endPScale = radius * 0.5;
    final double extra = datetime.minute / 60.0;
    double angle = (hour + extra) * 180 / 12 - 90;
    // draw hour hand
    Offset hourHand1 = Offset(
        radius - cos(degToRad(angle)) * endPScale,
        radius - sin(degToRad(angle)) * endPScale);
    Offset hourHand2 = Offset(
        radius + cos(degToRad(angle)) * startPscale,
        radius + sin(degToRad(angle)) * startPscale);
    final hourPaint = Paint()
      ..color = handColor
      ..strokeWidth = 8 * scale;
    canvas.drawLine(hourHand2, hourHand1, hourPaint);

    // draw minute hand
    startPscale = radius * 0.3;
    endPScale = radius - borderWidth * 3;
    angle = 180 / 60 * minute - 90;
    Offset minuteHand1 = Offset(
        radius - cos(degToRad(angle)) * endPScale,
        radius - sin(degToRad(angle)) * endPScale);
    Offset minuteHand2 = Offset(
        radius + cos(degToRad(angle)) * startPscale,
        radius + sin(degToRad(angle)) * startPscale);
    final minutePaint = Paint()
      ..color = handColor
      ..strokeWidth = 3 * scale;
    canvas.drawLine(minuteHand2, minuteHand1, minutePaint);

    // draw second hand
    angle = 180 / 60 * second - 90;
    Offset secondHand1 = Offset(
        radius - cos(degToRad(angle)) * endPScale,
        radius - sin(degToRad(angle)) * endPScale);
    Offset secondHand2 = Offset(
        radius + cos(degToRad(angle)) * startPscale,
        radius + sin(degToRad(angle)) * startPscale);
    final secondPaint = Paint()
      ..color = handColor
      ..strokeWidth = 1 * scale;
    canvas.drawLine(secondHand2, secondHand1, secondPaint);

    final centerPaint = Paint()
      ..strokeWidth = 2 * scale
      ..style = PaintingStyle.stroke
      ..color = Colors.yellow;
    canvas.drawCircle(Offset(radius, radius), 4 * scale, centerPaint);
  }

  double drawCross(Canvas canvas, double upper) {
    final double mRadius = upper - borderWidth * 1.5;
    final crossColor = [Colors.green, Colors.red, Colors.blue];
    final crossPaint = Paint()
      ..color = crossColor[datetime.minute % 3]
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2 * scale;
    final double crossRadius = 7 * scale;

    void drawMemoria() {
      void drawYear(int direct, String year) {
        // Unused variable removed.
        double extraSpace = crossRadius * 2;
        double exAngle = asin(extraSpace / mRadius);

        canvas.save();
        canvas.rotate(direct * exAngle);
        for (int i = 0; i < year.length; i++) {
          textPainter.text = TextSpan(
            text: "${year[i]}",
            style: TextStyle(
              fontStyle: FontStyle.italic,
              color: Colors.green,
              fontSize: 14.0 * scale,
            ),
          );
          final double angle = degToRad(180 / 60);
          textPainter.layout();
          canvas.rotate(direct * angle);
          textPainter.paint(
              canvas,
              Offset(-textPainter.width / 2,
                  -textPainter.height / 2 - mRadius));
        }
        canvas.restore();
      }

      drawYear(-1, "1993.9.1");
      drawYear(1,
          "${datetime.year}.${datetime.month}.${datetime.day}");
    }

    drawMemoria();

    canvas.save();
    canvas.translate(0, -mRadius);
    canvas.rotate(-degToRad(360 / 60 * datetime.second));

    for (double startP = 0; startP < 360; startP += 90) {
      canvas.drawArc(
          Rect.fromCircle(center: const Offset(0, 0), radius: crossRadius),
          degToRad(startP),
          degToRad(45),
          false,
          crossPaint);
    }
    canvas.restore();
    return mRadius - crossRadius;
  }

  void drawJ33(Canvas canvas, double upper) {
    final double mRadius = upper - borderWidth;
    textPainter.text = const TextSpan(
      text: "J",
      style: TextStyle(
        fontStyle: FontStyle.italic,
        color: Colors.green,
        fontSize: 28.0,
      ),
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(-textPainter.width, -mRadius));

    textPainter.text = const TextSpan(
      text: "33",
      style: TextStyle(
        fontStyle: FontStyle.italic,
        color: Colors.green,
        fontSize: 14.0,
      ),
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(0, -mRadius + textPainter.height / 2));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

double degToRad(double deg) => deg * (pi / 180.0);
double radToDeg(double rad) => rad * (180.0 / pi);