import '../../../extensions.dart';
import './event.dart';
import 'package:flutter/gestures.dart';

class DragEndEvent extends Event<DragEndDetails> {
  DragEndEvent(this.pointerId, DragEndDetails details)
    : velocity = details.velocity.pixelsPerSecond.toVector2(),
      super(raw: details);

  final int pointerId;

  final Vector2 velocity;

  @override
  String toString() =>
      'DragEndEvent(pointerId: $pointerId, velocity: $velocity)';
}
