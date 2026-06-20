import 'dart:async';
import 'package:flutter/material.dart';

import 'model.dart';
import 'constants.dart';
import 'painters/snake.dart';
import 'painters/indicators.dart';

class SnakeClock extends StatefulWidget {
  const SnakeClock(this.model, {super.key});

  final ClockModel model;

  @override
  State<SnakeClock> createState() => _SnakeClockState();
}

class _SnakeClockState extends State<SnakeClock> {
  DateTime _dateTime = DateTime.now();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(SnakeClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    widget.model.dispose();
    super.dispose();
  }

  void _updateModel() {
    setState(() {});
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
    final colors = Theme.of(context).brightness == Brightness.light ? lightTheme : darkTheme;

    if (_dateTime.month >= seasons[Season.winter]!.month ||
        _dateTime.month < seasons[Season.spring]!.month) {
      colors[Entity.body] = colors[Entity.winter];
    } else if (_dateTime.month >= seasons[Season.fall]!.month) {
      colors[Entity.body] = colors[Entity.fall];
    } else if (_dateTime.month >= seasons[Season.summer]!.month) {
      colors[Entity.body] = colors[Entity.summer];
    } else {
      colors[Entity.body] = colors[Entity.spring];
    }

    return ClipRect(
      child: CustomPaint(
        painter: SnakePainter(_dateTime, colors),
        foregroundPainter: IndicationsPainter(_dateTime, colors, widget.model.is24HourFormat),
      ),
    );
  }
}
