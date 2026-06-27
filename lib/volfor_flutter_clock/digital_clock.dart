// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'deps/flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'deps/intl/intl.dart';

import 'clock_palette.dart';
import 'digit.dart';

class DigitalClock extends StatefulWidget {
  const DigitalClock(this.model, {super.key, this.palette});

  final ClockModel model;
  final ClockPalette? palette;

  @override
  _DigitalClockState createState() => _DigitalClockState();
}

class _DigitalClockState extends State<DigitalClock> {
  StreamController<String> _hourStream = StreamController.broadcast();
  StreamController<String> _minuteStream = StreamController.broadcast();
  StreamController<String> _secondStream = StreamController.broadcast();

  DateTime _dateTime = DateTime.now();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateTime();
      _updateModel();
    });
  }

  @override
  void didUpdateWidget(DigitalClock oldWidget) {
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
    _hourStream.close();
    _minuteStream.close();
    _secondStream.close();
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      // Cause the clock to rebuild when the model changes.
    });
  }

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();
      // Update once per minute. If you want to update every second, use the
      // following code.
//      _timer = Timer(
//        Duration(minutes: 1) -
//            Duration(seconds: _dateTime.second) -
//            Duration(milliseconds: _dateTime.millisecond),
//        _updateTime,
//      );

      final hour = DateFormat(widget.model.is24HourFormat ? 'HH' : 'hh')
          .format(_dateTime);
      final minute = DateFormat('mm').format(_dateTime);
      final second = DateFormat('ss').format(_dateTime);

      _hourStream.add(hour);
      _minuteStream.add(minute);
      _secondStream.add(second);

      // Update once per second, but make sure to do it at the beginning of each
      // new second, so that the clock is accurate.
      _timer = Timer(
        Duration(seconds: 1) - Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = widget.palette?.background ??
        (isDark ? Colors.black : Colors.white);
    final arrows = widget.palette?.arrows ??
        (isDark ? Colors.white : Colors.black);
    final circlesBg = widget.palette?.circlesBackground ??
        (isDark ? Colors.white12 : Colors.black12);

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        var offset = 16;

        var c = constraints.maxWidth / 8;
        var smallCellSize = c / 2;

        var cellSize =
            (constraints.maxWidth - (smallCellSize * 4) - offset) / 8.0;

        return Container(
          color: bg,
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Digit(_hourStream, true, arrows, circlesBg, cellSize),
                Digit(_hourStream, false, arrows, circlesBg, cellSize),
                Digit(_minuteStream, true, arrows, circlesBg, cellSize),
                Digit(_minuteStream, false, arrows, circlesBg, cellSize),
                Digit(_secondStream, true, arrows, circlesBg, smallCellSize),
                Digit(_secondStream, false, arrows, circlesBg, smallCellSize),
              ],
            ),
          ),
        );
      },
    );
  }
}
