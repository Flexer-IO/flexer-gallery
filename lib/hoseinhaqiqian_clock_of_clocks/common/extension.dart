import '../models/clock_builder.dart';
import '../models/tiny_clock.dart';

extension Converter on int {
  List<TinyClock> getValue() {
    switch (this) {
      case 0:
        return ClockBuilder.Zero;
      case 1:
        return ClockBuilder.One;
      case 2:
        return ClockBuilder.Two;
      case 3:
        return ClockBuilder.Three;
      case 4:
        return ClockBuilder.Four;
      case 5:
        return ClockBuilder.Five;
      case 6:
        return ClockBuilder.Six;
      case 7:
        return ClockBuilder.Seven;
      case 8:
        return ClockBuilder.Eight;
      case 9:
        return ClockBuilder.Nine;
    }
    return ClockBuilder.Divider;
  }

  List<int> splitter() {
    if ((this / 10) >= 1) {
      toString().split("").map((e) => int.parse(e)).toList().forEach((element) {
        // No operation needed; retained for side‑effects if any.
      });
      return toString().split("").map((e) => int.parse(e)).toList();
    } else {
      return [0, this];
    }
  }
}