import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'clock_hand_hour.dart';
import 'clock_hand_minute.dart';
import 'clock_hand_second.dart';

class ClockHands extends StatefulWidget {
  @override
  _ClockHandsState createState() => _ClockHandsState();
}

class _ClockHandsState extends State<ClockHands> {
  late Timer _timer;
  late DateTime dateTime;

  @override
  void initState() {
    super.initState();
    dateTime = DateTime.now();

    //Update dateTime every second
    _timer = Timer.periodic(const Duration(seconds: 1), setTime);
  }

  void setTime(Timer timer) {
    setState(() {
      dateTime = DateTime.now();
    });
  }

  @override
  void dispose() {
    //Make sure to stop timer
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20.0),
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            CustomPaint(
              painter: HourHandPainter(
                hours: dateTime.hour,
                minutes: dateTime.minute,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            CustomPaint(
              painter: MinuteHandPainter(
                minutes: dateTime.minute,
                seconds: dateTime.second,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            CustomPaint(
              painter: SecondHandPainter(
                seconds: dateTime.second,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}