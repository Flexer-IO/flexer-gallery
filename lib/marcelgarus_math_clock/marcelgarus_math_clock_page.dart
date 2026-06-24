import 'dart:async';

import 'package:flutter/material.dart';
import 'math_clock.dart';
import 'theme.dart';

class MarcelgarusMathClockPage extends StatefulWidget {
  const MarcelgarusMathClockPage({super.key});

  @override
  State<MarcelgarusMathClockPage> createState() =>
      _MarcelgarusMathClockPageState();
}

class _MarcelgarusMathClockPageState extends State<MarcelgarusMathClockPage> {
  late DateTime _dateTime;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _updateTime();
  }

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();
      final nextMinute = Duration(minutes: 1) -
          Duration(seconds: _dateTime.second) -
          Duration(milliseconds: _dateTime.millisecond);
      _timer?.cancel();
      _timer = Timer(nextMinute, _updateTime);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MathClock(
        now: _dateTime,
        weather: WeatherCondition.sunny,
      ),
    );
  }
}