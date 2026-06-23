import 'package:flutter/material.dart';
import 'deps/provider/provider.dart';

import 'clock/clock_painter.dart';
import 'models/time.dart';
import 'shared/widgets/clock_container.dart';

class SecondFace extends StatelessWidget {
  /// Display the second hand of the clock...
  const SecondFace({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //

    return ClockContainer(
      decoration: BoxDecoration(shape: BoxShape.circle),
      child: Consumer<TimeModel>(
        builder: (_, model, __) {
          //
          return CustomPaint(
            painter: GenericPainter(
              clockHand: ClockHand.second,
              hours: model.currentHour,
              minutes: model.currentMinute,
              seconds: model.currentSecond,
            ),
          );
        },
      ),
    );
  }
}
