import 'package:flutter/material.dart';
import 'clock_dial_painter.dart';
import 'clock_hands.dart';
import 'clock_text.dart';

class ClockFace extends StatelessWidget {
  final DateTime dateTime;
  final ClockText clockText;

  const ClockFace({
    Key? key,
    this.clockText = ClockText.arabic,
    required this.dateTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: AspectRatio(
        aspectRatio: 1.0,
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xfff4f9fd),
          ),
          child: Stack(
            children: <Widget>[
              Container(
                width: double.infinity,
                height: double.infinity,
                padding: const EdgeInsets.all(10.0),
                child: CustomPaint(
                  painter: ClockDialPainter(clockText: clockText),
                ),
              ),
              ClockHands(dateTime: dateTime),
            ],
          ),
        ),
      ),
    );
  }
}