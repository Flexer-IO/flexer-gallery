import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/animation.dart';

class CreativecreatorormaybenotClockPage extends StatefulWidget {
  const CreativecreatorormaybenotClockPage({super.key});

  @override
  State<CreativecreatorormaybenotClockPage> createState() =>
      _CreativecreatorormaybenotClockPageState();
}

class _CreativecreatorormaybenotClockPageState
    extends State<CreativecreatorormaybenotClockPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _secondController;
  bool _showHourHand = true;

  @override
  void initState() {
    super.initState();
    _secondController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60),
    )..repeat();
  }

  @override
  void dispose() {
    _secondController.dispose();
    super.dispose();
  }

  void _toggleHourHand() {
    setState(() {
      _showHourHand = !_showHourHand;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      body: SafeArea(
        child: Column(
          children: [
            const Expanded(
              child: Center(
                child: Text(
                  'Creativecreatorormaybenot Clock Demo',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: GestureDetector(
                  onTap: _toggleHourHand,
                  child: AnimatedBuilder(
                    animation: _secondController,
                    builder: (context, child) {
                      return CustomPaint(
                        size: const Size(250, 250),
                        painter: _ClockPainter(
                          secondAngle:
                              _secondController.value * 2 * pi,
                          showHourHand: _showHourHand,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12.0),
              child: Text(
                'Tap the clock to toggle hour hand',
                style: TextStyle(color: Colors.white54, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ClockPainter extends CustomPainter {
  final double secondAngle;
  final bool showHourHand;

  _ClockPainter({
    required this.secondAngle,
    required this.showHourHand,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.shortestSide / 2;

    final facePaint = Paint()
      ..color = const Color(0xFF1E1E1E)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius, facePaint);

    final outlinePaint = Paint()
      ..color = Colors.white24
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(center, radius, outlinePaint);

    // Draw hour markers
    final markerPaint = Paint()
      ..color = Colors.white70
      ..strokeWidth = 2;
    for (int i = 0; i < 12; i++) {
      final angle = i * 2 * pi / 12;
      final inner = Offset(
        center.dx + (radius - 12) * cos(angle),
        center.dy + (radius - 12) * sin(angle),
      );
      final outer = Offset(
        center.dx + radius * cos(angle),
        center.dy + radius * sin(angle),
      );
      canvas.drawLine(inner, outer, markerPaint);
    }

    final now = DateTime.now();
    final hour = now.hour % 12 + now.minute / 60.0;
    final minute = now.minute + now.second / 60.0;

    // Hour hand
    if (showHourHand) {
      final hourAngle = hour * 2 * pi / 12;
      final hourHandPaint = Paint()
        ..color = Colors.white70
        ..strokeWidth = 6
        ..strokeCap = StrokeCap.round;
      final hourHandEnd = Offset(
        center.dx + (radius * 0.5) * cos(hourAngle - pi / 2),
        center.dy + (radius * 0.5) * sin(hourAngle - pi / 2),
      );
      canvas.drawLine(center, hourHandEnd, hourHandPaint);
    }

    // Minute hand
    final minuteAngle = minute * 2 * pi / 60;
    final minuteHandPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    final minuteHandEnd = Offset(
      center.dx + (radius * 0.75) * cos(minuteAngle - pi / 2),
      center.dy + (radius * 0.75) * sin(minuteAngle - pi / 2),
    );
    canvas.drawLine(center, minuteHandEnd, minuteHandPaint);

    // Second hand
    final secondHandPaint = Paint()
      ..color = Colors.redAccent
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    final secondHandEnd = Offset(
      center.dx + (radius * 0.85) * cos(secondAngle - pi / 2),
      center.dy + (radius * 0.85) * sin(secondAngle - pi / 2),
    );
    canvas.drawLine(center, secondHandEnd, secondHandPaint);

    // Center dot
    final centerDotPaint = Paint()..color = Colors.white;
    canvas.drawCircle(center, 4, centerDotPaint);
  }

  @override
  bool shouldRepaint(covariant _ClockPainter oldDelegate) {
    return oldDelegate.secondAngle != secondAngle ||
        oldDelegate.showHourHand != showHourHand;
  }
}