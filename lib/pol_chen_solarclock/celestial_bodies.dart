import 'dart:math';

import 'package:flutter/material.dart';

// Each widget uses SizedBox.expand + CustomPaint so it overlays the full Stack.
// The [center] and [radius] parameters position the body within the canvas.

class SunBody extends StatelessWidget {
  const SunBody({
    super.key,
    required this.center,
    required this.radius,
    required this.color,
  });

  final Offset center;
  final double radius;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: CustomPaint(painter: _SunPainter(center, radius, color)),
    );
  }
}

class EarthBody extends StatelessWidget {
  const EarthBody({
    super.key,
    required this.center,
    required this.radius,
    required this.color,
  });

  final Offset center;
  final double radius;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: CustomPaint(painter: _EarthPainter(center, radius, color)),
    );
  }
}

class MoonBody extends StatelessWidget {
  const MoonBody({
    super.key,
    required this.center,
    required this.radius,
    required this.color,
  });

  final Offset center;
  final double radius;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: CustomPaint(painter: _MoonPainter(center, radius, color)),
    );
  }
}

// ─── Sun ────────────────────────────────────────────────────────────────────

class _SunPainter extends CustomPainter {
  const _SunPainter(this.center, this.radius, this.color);

  final Offset center;
  final double radius;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;

    // Outer halo
    canvas.drawCircle(
      center,
      radius * 1.55,
      Paint()
        ..color = color.withValues(alpha: 0.08)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18),
    );

    // Mid glow
    canvas.drawCircle(
      center,
      radius * 1.2,
      Paint()
        ..color = color.withValues(alpha: 0.18)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );

    // Rays — 12 spikes alternating long/short
    final rayPaint = Paint()
      ..color = color.withValues(alpha: 0.55)
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    for (var i = 0; i < 12; i++) {
      final angle = i * (pi / 6);
      final isLong = i % 3 == 0;
      final inner = radius * 1.15;
      final outer = radius * (isLong ? 1.65 : 1.40);
      canvas.drawLine(
        center + Offset.fromDirection(angle, inner),
        center + Offset.fromDirection(angle, outer),
        rayPaint,
      );
    }

    // Core disc
    canvas.drawCircle(center, radius, paint);

    // Bright inner highlight
    canvas.drawCircle(
      center + Offset(-radius * 0.25, -radius * 0.25),
      radius * 0.35,
      Paint()..color = Colors.white.withValues(alpha: 0.25),
    );
  }

  @override
  bool shouldRepaint(_SunPainter old) =>
      old.center != center || old.radius != radius || old.color != color;
}

// ─── Earth ──────────────────────────────────────────────────────────────────

class _EarthPainter extends CustomPainter {
  const _EarthPainter(this.center, this.radius, this.color);

  final Offset center;
  final double radius;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    // Ocean base
    canvas.drawCircle(center, radius, Paint()..color = color);

    // Clip continent blobs to the circle
    canvas.save();
    canvas.clipPath(
      Path()..addOval(Rect.fromCircle(center: center, radius: radius)),
    );

    final landColor = Color.lerp(color, Colors.green.shade300, 0.45)!;
    final landPaint = Paint()..color = landColor;

    // Three continent-ish blobs
    canvas.drawOval(
      Rect.fromCenter(
        center: center + Offset(-radius * 0.25, -radius * 0.2),
        width: radius * 0.9,
        height: radius * 0.7,
      ),
      landPaint,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: center + Offset(radius * 0.35, radius * 0.3),
        width: radius * 0.6,
        height: radius * 0.75,
      ),
      landPaint,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: center + Offset(-radius * 0.1, radius * 0.5),
        width: radius * 0.55,
        height: radius * 0.35,
      ),
      landPaint,
    );

    canvas.restore();

    // Atmosphere ring
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = Colors.lightBlue.withValues(alpha: 0.20)
        ..style = PaintingStyle.stroke
        ..strokeWidth = radius * 0.22,
    );

    // Specular highlight
    canvas.drawOval(
      Rect.fromCenter(
        center: center + Offset(-radius * 0.28, -radius * 0.28),
        width: radius * 0.45,
        height: radius * 0.3,
      ),
      Paint()..color = Colors.white.withValues(alpha: 0.20),
    );
  }

  @override
  bool shouldRepaint(_EarthPainter old) =>
      old.center != center || old.radius != radius || old.color != color;
}

// ─── Moon ───────────────────────────────────────────────────────────────────

class _MoonPainter extends CustomPainter {
  const _MoonPainter(this.center, this.radius, this.color);

  final Offset center;
  final double radius;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    // Base
    canvas.drawCircle(center, radius, Paint()..color = color);

    // Clip craters to circle
    canvas.save();
    canvas.clipPath(
      Path()..addOval(Rect.fromCircle(center: center, radius: radius)),
    );

    final craterColor = Color.lerp(color, Colors.black, 0.28)!;
    final craterPaint = Paint()..color = craterColor;

    // Three craters scaled to radius
    canvas.drawCircle(
      center + Offset(radius * 0.30, -radius * 0.25),
      radius * 0.22,
      craterPaint,
    );
    canvas.drawCircle(
      center + Offset(-radius * 0.35, radius * 0.20),
      radius * 0.18,
      craterPaint,
    );
    canvas.drawCircle(
      center + Offset(radius * 0.05, radius * 0.42),
      radius * 0.14,
      craterPaint,
    );

    canvas.restore();

    // Highlight
    canvas.drawOval(
      Rect.fromCenter(
        center: center + Offset(-radius * 0.25, -radius * 0.25),
        width: radius * 0.38,
        height: radius * 0.25,
      ),
      Paint()..color = Colors.white.withValues(alpha: 0.28),
    );
  }

  @override
  bool shouldRepaint(_MoonPainter old) =>
      old.center != center || old.radius != radius || old.color != color;
}
