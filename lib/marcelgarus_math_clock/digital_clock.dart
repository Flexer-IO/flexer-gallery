// Copyright 2019 The Chromium Authors. All rights reserved.
 // Use of this source code is governed by a BSD-style license that can be
 // found in the LICENSE file.
 
 import 'dart:async';
 import 'package:flutter/material.dart';
 import 'math_clock.dart';
 import 'package:flutter/foundation.dart';
 import 'theme.dart';
 
 /// Minimal stub for the weather condition enum expected from the original
 /// `flutter_clock_helper` package. Renamed to avoid conflict with the
 /// `WeatherCondition` defined in `theme.dart`.
 enum HelperWeatherCondition {
   sunny,
   cloudy,
   rainy,
   snowy,
   unknown,
 }
 
 /// Minimal stub for the ClockModel used by the digital clock.
 /// This mirrors the API expected from the original `flutter_clock_helper` package.
 class ClockModel extends ChangeNotifier {
   /// The current weather condition, e.g. HelperWeatherCondition.sunny,
   /// HelperWeatherCondition.cloudy, etc. It may be null if no data is available.
   HelperWeatherCondition? weatherCondition;
 
   /// Adds a listener that is called when the model changes.
   @override
   void addListener(VoidCallback listener) => super.addListener(listener);
 
   /// Removes a previously added listener.
   @override
   void removeListener(VoidCallback listener) => super.removeListener(listener);
 
   /// Disposes the model and releases any resources.
   @override
   void dispose() {
     super.dispose();
   }
 }
 
 /// A basic digital clock.
 class DigitalClock extends StatefulWidget {
   const DigitalClock(this.model, {Key? key}) : super(key: key);
 
   final ClockModel model;
 
   @override
   _DigitalClockState createState() => _DigitalClockState();
 }
 
 class _DigitalClockState extends State<DigitalClock> {
   late DateTime _dateTime;
   Timer? _timer;
 
   @override
   void initState() {
     super.initState();
     widget.model.addListener(_updateModel);
     _updateTime();
     _updateModel();
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
     super.dispose();
   }
 
   void _updateModel() {
     setState(() {
       // Cause the clock to rebuild when the model changes.
     });
   }
 
   void _updateTime() {
     setState(() {
       // Update once per minute.
       _dateTime = DateTime.now();
       _timer = Timer(
         Duration(minutes: 1) -
             Duration(seconds: _dateTime.second) -
             Duration(milliseconds: _dateTime.millisecond),
         _updateTime,
       );
     });
   }
 
   /// Converts a [HelperWeatherCondition] (or null) to the [WeatherCondition]
   /// expected by [MathClock].
   WeatherCondition _mapWeather(HelperWeatherCondition? condition) {
     switch (condition) {
       case HelperWeatherCondition.sunny:
         return WeatherCondition.sunny;
       case HelperWeatherCondition.cloudy:
         return WeatherCondition.cloudy;
       case HelperWeatherCondition.rainy:
         return WeatherCondition.rainy;
       case HelperWeatherCondition.snowy:
         return WeatherCondition.snowy;
       case HelperWeatherCondition.unknown:
       case null:
         // Fallback to a default weather condition since the original
         // WeatherCondition enum does not define an 'unknown' value.
         return WeatherCondition.sunny;
     }
   }
 
   @override
   Widget build(BuildContext context) => MathClock(
         now: _dateTime,
         weather: _mapWeather(widget.model.weatherCondition),
       );
 }