import 'dart:async';

import 'package:flutter/material.dart';

import 'deps/flutter_clock_helper/model.dart';
import 'weather_service.dart';

typedef ModelBuilder = Widget Function(BuildContext context, ClockModel model);

class RealWeatherCustomizer extends StatefulWidget {
  final ModelBuilder builder;
  const RealWeatherCustomizer({super.key, required this.builder});

  @override
  State<RealWeatherCustomizer> createState() => _RealWeatherCustomizerState();
}

class _RealWeatherCustomizerState extends State<RealWeatherCustomizer> {
  late final ClockModel _model;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _model = ClockModel()
      ..unit = TemperatureUnit.celsius
      ..location = ''
      ..temperature = 20
      ..high = 24
      ..low = 16
      ..weatherCondition = WeatherCondition.sunny;
    _fetch();
    _timer = Timer.periodic(const Duration(minutes: 10), (_) => _fetch());
  }

  Future<void> _fetch() async {
    final data = await WeatherService.fetch();
    if (data == null || !mounted) return;
    setState(() {
      // unit must be celsius before setting temps so no conversion happens
      _model.unit = TemperatureUnit.celsius;
      _model.location = data.city;
      _model.temperature = data.tempC;
      _model.high = data.highC;
      _model.low = data.lowC;
      _model.weatherCondition = data.condition;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, _model);
}
