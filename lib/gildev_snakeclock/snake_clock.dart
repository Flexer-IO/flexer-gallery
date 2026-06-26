import 'dart:async';
import 'package:flutter/material.dart';

import 'constants.dart';
import 'painters/snake.dart';
import 'painters/indicators.dart';

class SnakeClock extends StatefulWidget {
  final Map<Entity, Color?> colors;
  const SnakeClock({super.key, required this.colors});

  @override
  State<SnakeClock> createState() => _SnakeClockState();
}

class _SnakeClockState extends State<SnakeClock> {
  DateTime _dateTime = DateTime.now();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _updateTime();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();
      _timer = Timer(
        Duration(seconds: 1) - Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: CustomPaint(
        painter: SnakePainter(_dateTime, widget.colors),
        foregroundPainter: IndicationsPainter(_dateTime, widget.colors, true),
      ),
    );
  }
}
