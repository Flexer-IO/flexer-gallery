import 'dart:async';

import 'analogue_clock_face.dart';
import 'clock_palette.dart';
import 'needle.dart';
import 'pin.dart';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

const _kDefaultPalette = ClockPalette([
  Color(0xFF120905),
  Color(0xFF381708),
  Color(0xFF7A0A75),
  Color(0xFF1438C7),
  Color(0xFF0839FF),
]);

class AnalogueClock extends StatefulWidget {
  const AnalogueClock({Key? key, this.palette}) : super(key: key);
  final ClockPalette? palette;

  @override
  State<AnalogueClock> createState() => _AnalogueClockState();
}

class _AnalogueClockState extends State<AnalogueClock> {
  late Timer _timer;
  DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _updateTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _updateTimer() {
    setState(() {
      _now = DateTime.now();
      _timer = Timer(
        Duration(milliseconds: 1) - Duration(microseconds: _now.microsecond),
        _updateTimer,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    final palette = widget.palette ?? _kDefaultPalette;

    return Stack(
      children: [
        CustomPaint(
          painter: BGPainter(bg: palette.bg, ring: palette.ring),
          size: screen,
        ),
        Positioned(
          top: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.all(8),
            child: Text(
              DateFormat.yMMMd().format(_now),
              style: TextStyle(fontSize: 20, color: palette.accent),
            ),
          ),
        ),
        Transform.translate(
          offset: Offset(0, screen.height / 2),
          child: AnalogueClockFace(now: _now, textColor: palette.text),
        ),
        Needle(
          top: screen.height / 4,
          color: palette.accent,
          child: Pin(
            alignment: Alignment.bottomCenter,
            color: palette.ring,
            radius: 25,
          ),
        ),
      ],
    );
  }
}

class BGPainter extends CustomPainter {
  const BGPainter({required this.bg, required this.ring});
  final Color bg;
  final Color ring;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final center = Offset(size.width / 2, size.height);
    final radius = size.height;

    paint.color = ring;
    canvas.drawCircle(center, radius * 9 / 10, paint);
    paint.color = bg;
    canvas.drawCircle(center, radius * 7 / 10, paint);
    paint.color = ring;
    canvas.drawCircle(center, radius * 5 / 10, paint);
    paint.color = bg;
    canvas.drawCircle(center, radius * 3 / 10, paint);
  }

  @override
  bool shouldRepaint(BGPainter old) => bg != old.bg || ring != old.ring;
}
