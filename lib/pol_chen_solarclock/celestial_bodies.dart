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
    // Ocean base
    canvas.drawCircle(center, radius, Paint()..color = color);

    // Clip continent blobs to the circle
    canvas.save();
    canvas.clipPath(
      Path()..addOval(Rect.fromCircle(center: center, radius: radius)),
    );

    // Ocean base — palette earthColor
    canvas.drawCircle(center, radius, Paint()..color = color);

    // Land: shift toward warm amber — contrasts naturally against any ocean hue
    final land = Color.lerp(color, const Color(0xFFD4A030), 0.62)!;
    // Ice: fixed pale blue-white — always reads as polar cap
    const ice = Color(0xFFDFF0F8);

    // Soft watercolor land blobs — blurred so edges bleed naturally
    void blob(Offset offset, double size, Color c) {
      canvas.drawCircle(
        center + offset * radius,
        size * radius,
        Paint()
          ..color = c
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, radius * 0.35),
      );
    }

    blob(const Offset(-0.20, -0.10), 0.55, land);
    blob(const Offset(0.30, 0.15), 0.40, land);
    blob(const Offset(-0.05, 0.40), 0.30, land);
    blob(const Offset(0.00, -0.55), 0.28, ice);

    // Sphere depth — radial dark edge
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..shader = RadialGradient(
          colors: [Colors.transparent, Colors.black.withValues(alpha: 0.32)],
          stops: const [0.55, 1.0],
        ).createShader(Rect.fromCircle(center: center, radius: radius)),
    );

    canvas.restore();

    // Thin atmosphere ring
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = Colors.lightBlue.withValues(alpha: 0.30)
        ..style = PaintingStyle.stroke
        ..strokeWidth = radius * 0.10,
    );

    // Specular highlight
    canvas.drawOval(
      Rect.fromCenter(
        center: center + Offset(-radius * 0.28, -radius * 0.28),
        width: radius * 0.38,
        height: radius * 0.24,
      ),
      Paint()..color = Colors.white.withValues(alpha: 0.22),
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
