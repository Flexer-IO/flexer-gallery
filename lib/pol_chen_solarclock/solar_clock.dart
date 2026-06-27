import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

import 'drawn_star.dart';
import 'model.dart';
import 'universe.dart';

double _deg2rad(double degrees) => degrees * pi / 180.0;

class SolarClock extends StatefulWidget {
  const SolarClock(this.model, {super.key});

  final ClockModel model;

  @override
  State<SolarClock> createState() => _SolarClockState();
}

class _SolarClockState extends State<SolarClock> {
  var _now = DateTime.now();
  var _condition = '';
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(SolarClock old) {
    super.didUpdateWidget(old);
    if (widget.model != old.model) {
      old.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    super.dispose();
  }

  void _updateModel() {
    setState(() => _condition = widget.model.weatherString);
  }

  void _updateTime() {
    setState(() {
      _now = DateTime.now();
      _timer = Timer(
        Duration(seconds: 1) - Duration(milliseconds: _now.millisecond),
        _updateTime,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        final time =
            '${_now.hour}:${_now.minute.toString().padLeft(2, '0')}:${_now.second.toString().padLeft(2, '0')}';
        final ratio = size.height / 414.0;

        final anchorRadius = 48.0 * ratio;
        final anchorCenter = size.center(Offset.zero);

        final hourRadius = 18.0 * ratio;
        final hourDistance = size.height / 2.0 - hourRadius - 20.0 * ratio;
        final hourRadian = _now.hour * _deg2rad(360 / 12) +
            _now.minute * _deg2rad(360 / 12 / 60) +
            _now.second * _deg2rad(360 / 12 / 60 / 60) -
            pi / 2.0;
        final hourCenter =
            anchorCenter + Offset.fromDirection(hourRadian, hourDistance);

        final minuteRadius = 8.0 * ratio;
        final minuteDistance = hourRadius + 10.0 * ratio + minuteRadius;
        final minuteRadian = _now.minute * _deg2rad(360 / 60) +
            _now.second * _deg2rad(360 / 60 / 60) -
            pi / 2.0;
        final minuteCenter =
            hourCenter + Offset.fromDirection(minuteRadian, minuteDistance);

        return Semantics.fromProperties(
          properties: SemanticsProperties(
            label: 'Solar Clock with time $time weather $_condition',
            value: time,
          ),
          child: Container(
            color: const Color(0xFF152440),
            child: Stack(
              children: [
                Universe(size: size),
                DrawnStar(
                  color: const Color(0xFFFFC107),
                  radius: anchorRadius,
                  center: anchorCenter,
                ),
                DrawnStar(
                  color: const Color(0xFF4CAF50),
                  radius: hourRadius,
                  center: hourCenter,
                ),
                DrawnStar(
                  color: const Color(0xFFBDBDBD),
                  radius: minuteRadius,
                  center: minuteCenter,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
