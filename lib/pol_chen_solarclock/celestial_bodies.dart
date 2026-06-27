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
    required this.sunCenter,
  });

  final Offset center;
  final double radius;
  final Color color;
  final Offset sunCenter;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: CustomPaint(
        painter: _EarthPainter(center, radius, color, sunCenter),
      ),
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
  const _EarthPainter(this.center, this.radius, this.color, this.sunCenter);

  final Offset center;
  final double radius;
  final Color color;
  final Offset sunCenter;

  // Three smooth organic blobs in normalized sphere coords (-1..1).
  // Coarse enough to look clean at small radii; clipped to the sphere circle.

  // Americas — left side
  static final _americas = Path()
    ..moveTo(-0.62, -0.52)
    ..quadraticBezierTo(-0.10, -0.58, -0.08, -0.10)
    ..quadraticBezierTo(-0.12, 0.48, -0.42, 0.66)
    ..quadraticBezierTo(-0.72, 0.52, -0.72, 0.05)
    ..quadraticBezierTo(-0.80, -0.28, -0.62, -0.52)
    ..close();

  // Eurasia + Africa — right side
  static final _eurasiaAfrica = Path()
    ..moveTo(0.08, -0.66)
    ..quadraticBezierTo(0.68, -0.58, 0.74, 0.02)
    ..quadraticBezierTo(0.58, 0.32, 0.28, 0.66)
    ..quadraticBezierTo(0.06, 0.72, -0.04, 0.46)
    ..quadraticBezierTo(-0.08, 0.08, 0.08, -0.22)
    ..quadraticBezierTo(0.02, -0.46, 0.08, -0.66)
    ..close();

  // Australia — small blob lower-right
  static final _australia = Path()
    ..moveTo(0.55, 0.26)
    ..quadraticBezierTo(0.82, 0.20, 0.84, 0.46)
    ..quadraticBezierTo(0.74, 0.58, 0.54, 0.50)
    ..close();

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromCircle(center: center, radius: radius);

    final toSun = sunCenter - center;
    final dist = toSun.distance;
    // Alignment offset for radial gradient ([-0.5, 0.5] range)
    final nx = dist > 0 ? (toSun.dx / dist) * 0.45 : -0.4;
    final ny = dist > 0 ? (toSun.dy / dist) * 0.45 : -0.4;
    // Raw unit sun direction for terminator / limb glow positioning
    final sdx = dist > 0 ? toSun.dx / dist : -0.89;
    final sdy = dist > 0 ? toSun.dy / dist : -0.89;

    // Ocean sphere with sun-facing highlight
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..shader = RadialGradient(
          center: Alignment(nx, ny),
          colors: const [
            Color(0xFF81D4FA),
            Color(0xFF1976D2),
            Color(0xFF0D2B6B),
          ],
          stops: const [0.0, 0.55, 1.0],
        ).createShader(rect),
    );

    // Continent blobs — translate+scale so paths live in normalized coords
    canvas.save();
    canvas.clipPath(Path()..addOval(rect));
    canvas.translate(center.dx, center.dy);
    canvas.scale(radius, radius);
    final land = Paint()..color = const Color(0xFF43A047);
    canvas.drawPath(_americas, land);
    canvas.drawPath(_eurasiaAfrica, land);
    canvas.drawPath(_australia, land);
    canvas.restore();

    // Night-side terminator — darkens land + ocean on shadow side uniformly
    canvas.save();
    canvas.clipPath(Path()..addOval(rect));
    canvas.drawCircle(
      center + Offset(-sdx * radius * 0.52, -sdy * radius * 0.52),
      radius * 1.05,
      Paint()
        ..color = const Color(0xBB000820)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, radius * 0.58),
    );
    // Atmospheric limb glow on sun-facing edge — ties Earth to the sun's halo
    canvas.drawCircle(
      center + Offset(sdx * radius * 0.52, sdy * radius * 0.52),
      radius * 0.72,
      Paint()
        ..color = const Color(0x2A9FDDFF)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, radius * 0.38),
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(_EarthPainter old) =>
      old.center != center ||
      old.radius != radius ||
      old.sunCenter != sunCenter;
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
    canvas.drawCircle(center, radius, Paint()..color = const Color(0xFFD8D8D8));

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
