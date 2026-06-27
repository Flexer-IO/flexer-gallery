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

    // Core disc — flat fill
    canvas.drawCircle(center, radius, Paint()..color = color);

    // Centered soft bloom on top
    canvas.drawCircle(
      center,
      radius * 0.55,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.30)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
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
    final rect = Rect.fromCircle(center: center, radius: radius);
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..shader = RadialGradient(
          center: const Alignment(-0.4, -0.4),
          colors: const [
            Color(0xFF81D4FA),
            Color(0xFF1976D2),
            Color(0xFF0D2B6B),
          ],
          stops: const [0.0, 0.55, 1.0],
        ).createShader(rect),
    );
  }

  @override
  bool shouldRepaint(_EarthPainter old) =>
      old.center != center || old.radius != radius;
}

// ─── Moon ───────────────────────────────────────────────────────────────────

class _MoonPainter extends CustomPainter {
  const _MoonPainter(this.center, this.radius, this.color);

  final Offset center;
  final double radius;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    // Fixed moon grey
    canvas.drawCircle(
      center,
      radius,
      Paint()..color = const Color(0xFFD8D8D8),
    );

    // Clip craters to circle
    canvas.save();
    canvas.clipPath(
      Path()..addOval(Rect.fromCircle(center: center, radius: radius)),
    );

    final craterPaint = Paint()..color = const Color(0xFFAAAAAA);

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
