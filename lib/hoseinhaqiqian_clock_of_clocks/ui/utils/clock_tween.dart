import 'package:flutter/animation.dart';
import '../../models/tiny_clock.dart';

class ClockTween extends Tween<TinyClock?> {
  ClockTween({TinyClock? begin, TinyClock? end})
      : super(begin: begin, end: end);

  @override
  TinyClock? lerp(double t) {
    final b = begin;
    final e = end;
    if (b == null || e == null) return null;
    return TinyClock(
      hour: b.hour + (e.hour - b.hour) * t,
      minutes: b.minutes + (e.minutes - b.minutes) * t,
    );
  }
}