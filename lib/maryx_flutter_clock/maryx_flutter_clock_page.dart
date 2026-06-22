import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'analog_clock.dart';
import 'container_hand.dart';
import 'drawn_hand.dart';
import 'hand.dart';
import 'main.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/semantics.dart';
import 'deps/intl/intl.dart';
import 'package:vector_math/vector_math_64.dart' show radians;

/// A minimal stub model that mimics the interface expected by [AnalogClock].
/// It provides default values and extends [ChangeNotifier] so that listeners
/// can be added and removed without errors.
class _DummyClockModel extends ChangeNotifier {
  String get temperatureString => '0°C';
  int get low => 0;
  String get highString => '0°C';
  String get weatherString => 'Clear';
  String get location => 'Nowhere';
}

class MaryxFlutterClockPage extends StatelessWidget {
  const MaryxFlutterClockPage({super.key});

  @override
  Widget build(BuildContext context) {
    // The AnalogClock widget expects a ClockModel instance. We provide a
    // dummy implementation that satisfies the required API.
    final dynamic dummyModel = _DummyClockModel();

    return Scaffold(
      body: Center(
        child: AnalogClock(dummyModel),
      ),
    );
  }
}
