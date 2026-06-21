import 'package:flutter/material.dart';
import '../services/time.dart';
import '../renderers/clock_face_painter.dart';
import '../renderers/clock_hand_painter.dart';
import '../renderers/tick_painter.dart';

class Clock extends StatelessWidget {
  const Clock({Key? key}) : super(key: key);

  Positioned _wrap(CustomPainter painter) =>
      Positioned.fill(child: CustomPaint(painter: painter));

  Widget assembleSelf(BuildContext context, AsyncSnapshot<TimeStub> snapshot) {
    final TimeStub? time = snapshot.data;
    final Color clockColor =
        Theme.of(context).textTheme.titleLarge?.color ?? Colors.black;
    final Color tickColor = Theme.of(context).colorScheme.background;

    return Stack(
      children: <Widget>[
        _wrap(ClockHandPainter(
            arcOffset: (time?.hour ?? 0).toDouble(),
            color: clockColor,
            short: true)),
        _wrap(ClockHandPainter(
            arcOffset: (time?.minute ?? 0).toDouble(),
            color: clockColor)),
        _wrap(ClockFacePainter(clockColor)),
        _wrap(TickPainter(
            arcOffset: (time?.second ?? 0).toDouble(),
            color: tickColor)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: StreamBuilder<TimeStub>(
        stream: TimeService.currentTime,
        builder: assembleSelf,
      ),
    );
  }
}