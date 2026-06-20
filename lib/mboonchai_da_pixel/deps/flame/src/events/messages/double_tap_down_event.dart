import '../../../extensions.dart';
import './position_event.dart';
import 'package:flutter/gestures.dart';

class DoubleTapDownEvent extends PositionEvent<TapDownDetails> {
  final PointerDeviceKind deviceKind;

  DoubleTapDownEvent(super.game, TapDownDetails details)
    : deviceKind = details.kind ?? PointerDeviceKind.unknown,
      super(
        raw: details,
        devicePosition: details.globalPosition.toVector2(),
      );
}
