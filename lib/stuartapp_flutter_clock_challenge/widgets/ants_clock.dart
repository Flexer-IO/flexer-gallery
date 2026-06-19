/* Copyright 2020 Stuart Delivery Limited. All rights reserved.
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'cloudy.dart';
import 'fog.dart';
import 'ground.dart';
import 'rain_drops.dart';
import 'snow_flakes.dart';
import 'thunder_lightning.dart';
import 'windy_leaves.dart';
import 'colony.dart';

// ---------------------------------------------------------------------------
// Stub definitions for ClockModel.
// The original project expects these to be provided by the helper package
// located at deps/flutter_clock_helper/model.dart. Since that import path is
// unavailable in this environment, we provide a minimal compatible definition
// here. It exposes the same public API used by this widget.
// ---------------------------------------------------------------------------

class ClockModel extends ChangeNotifier {
  // Whether the clock should display time in 24‑hour format.
  bool is24HourFormat = false;

  // Current weather condition; using `dynamic` to stay compatible with the
  // various WeatherCondition enums defined in the individual widget files.
  dynamic weatherCondition;

  // The helper package normally provides addListener/removeListener via
  // ChangeNotifier, so we simply expose the inherited methods.
  @override
  void addListener(VoidCallback listener) => super.addListener(listener);

  @override
  void removeListener(VoidCallback listener) => super.removeListener(listener);

  @override
  void dispose() {
    super.dispose();
  }
}

// ---------------------------------------------------------------------------

class AntsClock extends StatefulWidget {
  const AntsClock(this.model, {super.key});

  final ClockModel model;

  @override
  _AntsClockState createState() => _AntsClockState();
}

class _AntsClockState extends State<AntsClock> {
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
  void didUpdateWidget(AntsClock oldWidget) {
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
        Duration(minutes: 1) -
            Duration(seconds: _dateTime.second) -
            Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final weather = widget.model.weatherCondition;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Ground(
      child: Stack(
        children: <Widget>[
          Colony(
            hour: widget.model.is24HourFormat
                ? _dateTime.hour
                : _formatTo12Hours(_dateTime.hour),
            minute: _dateTime.minute,
            isDarkMode: isDarkMode,
          ),
          WindyLeaves(
            weatherCondition: weather,
            isDarkMode: isDarkMode,
          ),
          RainDrops(
            weatherCondition: weather,
            isDarkMode: isDarkMode,
          ),
          ThunderLightning(weatherCondition: weather, isDarkMode: isDarkMode),
          Cloudy(weatherCondition: weather, isDarkMode: isDarkMode),
          Fog(weatherCondition: weather, isDarkMode: isDarkMode),
          SnowFlakes(
            weatherCondition: weather,
            isDarkMode: isDarkMode,
          ),
        ],
      ),
      weatherCondition: weather,
      isDarkMode: isDarkMode,
    );
  }

  int _formatTo12Hours(int hour) {
    return hour <= 12 ? hour : hour - 12;
  }
}