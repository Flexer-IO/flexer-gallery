import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

import 'celestial_bodies.dart';
import 'palette.dart';
import 'universe.dart';

double _deg2rad(double degrees) => degrees * pi / 180.0;

class SolarClock extends StatefulWidget {
  const SolarClock({super.key, required this.palette});

  final SolarPalette palette;

  @override
  State<SolarClock> createState() => _SolarClockState();
}

class _SolarClockState extends State<SolarClock> {
  var _now = DateTime.now();
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
        final hourOrbitRadius = size.height / 2.0 - hourRadius - 20.0 * ratio;
        final hourRadian =
            _now.hour * _deg2rad(360 / 12) +
            _now.minute * _deg2rad(360 / 12 / 60) +
            _now.second * _deg2rad(360 / 12 / 60 / 60) -
            pi / 2.0;
        final hourCenter =
            anchorCenter + Offset.fromDirection(hourRadian, hourOrbitRadius);

        final minuteRadius = 8.0 * ratio;
        final minuteOrbitRadius = hourRadius + 10.0 * ratio + minuteRadius;
        final minuteRadian =
            _now.minute * _deg2rad(360 / 60) +
            _now.second * _deg2rad(360 / 60 / 60) -
            pi / 2.0;
        final minuteCenter =
            hourCenter + Offset.fromDirection(minuteRadian, minuteOrbitRadius);

        return Semantics.fromProperties(
          properties: SemanticsProperties(
            label: 'Solar Clock, time $time',
            value: time,
          ),
          child: Stack(
            children: [
              // Full-screen animated space background
              Positioned.fill(
                child: Universe(
                  bgStart: widget.palette.bgStart,
                  bgEnd: widget.palette.bgEnd,
                ),
              ),
              // Clock face: orbit ring + 12 hour markers
              Positioned.fill(
                child: CustomPaint(
                  painter: _ClockFacePainter(
                    center: anchorCenter,
                    orbitRadius: hourOrbitRadius,
                    markerColor: widget.palette.markerColor,
                    ratio: ratio,
                  ),
                ),
              ),
              SunBody(
                color: widget.palette.sunColor,
                radius: anchorRadius,
                center: anchorCenter,
              ),
              EarthBody(
                color: widget.palette.earthColor,
                radius: hourRadius,
                center: hourCenter,
                sunCenter: anchorCenter,
              ),
              MoonBody(
                color: widget.palette.moonColor,
                radius: minuteRadius,
                center: minuteCenter,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ClockFacePainter extends CustomPainter {
  const _ClockFacePainter({
    required this.center,
    required this.orbitRadius,
    required this.markerColor,
    required this.ratio,
  });

  final Offset center;
  final double orbitRadius;
  final Color markerColor;
  final double ratio;

  @override
  void paint(Canvas canvas, Size size) {
    final ringPaint = Paint()
      ..color = markerColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    // Faint orbit ring
    canvas.drawCircle(center, orbitRadius, ringPaint);

    final dotPaint = Paint()..style = PaintingStyle.fill;

    for (var i = 0; i < 12; i++) {
      final angle = i * _deg2rad(30) - pi / 2;
      final pos = center + Offset.fromDirection(angle, orbitRadius);

      // Cardinal positions (12/3/6/9) slightly larger
      final isCardinal = i % 3 == 0;
      final dotRadius = isCardinal ? 3.5 * ratio : 2.0 * ratio;
      final opacity = isCardinal ? 0.45 : 0.25;

      dotPaint.color = markerColor.withValues(alpha: opacity);
      canvas.drawCircle(pos, dotRadius, dotPaint);
    }
  }

  @override
  bool shouldRepaint(_ClockFacePainter old) =>
      old.center != center ||
      old.orbitRadius != orbitRadius ||
      old.markerColor != markerColor;
}
