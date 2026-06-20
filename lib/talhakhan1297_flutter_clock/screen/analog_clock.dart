import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:intl/intl.dart';
import 'package:vector_math/vector_math_64.dart' show radians;

import '../elements/clock_face.dart';
import '../elements/container_hand.dart';
import '../elements/drawn_hand.dart';
import '../model.dart';

final _radiansPerTick = radians(360 / 60);
final _radiansPerHour = radians(360 / 12);

class AnalogClock extends StatefulWidget {
  const AnalogClock(this.model);

  final ClockModel model;

  @override
  State<AnalogClock> createState() => _AnalogClockState();
}

class _AnalogClockState extends State<AnalogClock> {
  var _now = DateTime.now();
  var _temperature = '';
  var _temperatureUnit = '';
  var _temperatureRange = '';
  var _condition = '';
  var _location = '';
  var _degreeSign = '';
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(AnalogClock oldWidget) {
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
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      _temperature = widget.model.temperatureString.split('.')[0];
      final s = widget.model.temperatureString;
      _temperatureUnit = s.substring(s.length - 1);
      _degreeSign = s.substring(s.length - 2, s.length - 1);
      _temperatureRange =
          '${widget.model.low} - ${widget.model.highString.split('°')[0]}';
      _condition = widget.model.weatherString;
      _location = widget.model.location;
    });
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF343334) : const Color(0xFFF2F0F2);
    final primary = isDark ? const Color(0xFFF2F0F2) : const Color(0xFF343334);
    const highlight = Color(0xFFFF3C3E);

    final time = DateFormat.Hms().format(_now);
    final weatherInfo = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: _temperature,
            style: TextStyle(
              color: primary,
              fontSize: 50,
              fontWeight: FontWeight.w700,
            ),
            children: [
              TextSpan(
                text: _degreeSign,
                style: TextStyle(color: highlight, fontSize: 60, fontWeight: FontWeight.w700),
              ),
              TextSpan(
                text: _temperatureUnit,
                style: TextStyle(color: primary, fontSize: 50, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: _temperatureRange,
            style: TextStyle(
              color: primary.withValues(alpha: 0.75),
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
            children: [
              TextSpan(
                text: _degreeSign,
                style: TextStyle(color: highlight.withValues(alpha: 0.75), fontSize: 24, fontWeight: FontWeight.w600),
              ),
              TextSpan(
                text: _temperatureUnit,
                style: TextStyle(color: primary.withValues(alpha: 0.75), fontSize: 20, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        if (_condition.isNotEmpty)
          Text(
            _condition[0].toUpperCase() + _condition.substring(1),
            style: TextStyle(color: highlight, fontSize: 50, fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
        Text(
          _location.replaceAll(', ', '\n'),
          style: TextStyle(
            color: primary.withValues(alpha: 0.75),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );

    final clockSize = MediaQuery.of(context).size.height * 0.65;
    return Semantics.fromProperties(
      properties: SemanticsProperties(
        label: 'Analog clock with time $time',
        value: time,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          weatherInfo,
          SizedBox(
            height: clockSize,
            width: clockSize,
            child: Stack(
              alignment: Alignment.center,
              children: [
                ClockFace(
                  datetime: _now,
                  width: clockSize,
                  color: bg,
                  tickColor: primary,
                  darkTheme: isDark,
                ),
                DrawnHand(
                  color: highlight,
                  thickness: 1,
                  size: 0.8,
                  angleRadians: _now.second * _radiansPerTick,
                ),
                DrawnHand(
                  color: highlight,
                  thickness: 2,
                  size: 0.7,
                  angleRadians: _now.minute * _radiansPerTick,
                ),
                ContainerHand(
                  color: Colors.transparent,
                  size: 0.5,
                  angleRadians: _now.hour * _radiansPerHour +
                      (_now.minute / 60) * _radiansPerHour,
                  child: Transform.translate(
                    offset: const Offset(0.0, -50.0),
                    child: Container(
                      width: 7,
                      height: 130,
                      decoration: BoxDecoration(color: primary),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.height * 0.055,
                  height: MediaQuery.of(context).size.height * 0.055,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: bg,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 2,
                        spreadRadius: 1,
                        color: primary.withValues(alpha: 0.1),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
