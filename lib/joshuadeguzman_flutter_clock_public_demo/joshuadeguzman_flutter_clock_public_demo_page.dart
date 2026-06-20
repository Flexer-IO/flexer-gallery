import 'package:flutter/material.dart';

import 'analog_clock.dart';

/// A thin wrapper page that displays the analog clock demo from the
/// `flutter_clock_public_demo` library.
///
/// This page creates a minimal dummy implementation of the required
/// `ClockModel` interface so that the [AnalogClock] widget can be instantiated
/// without pulling in the external `flutter_clock_helper` package.
class JoshuadeguzmanFlutterClockPublicDemoPage extends StatelessWidget {
  const JoshuadeguzmanFlutterClockPublicDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const AnalogClock(_DummyClockModel()),
    );
  }
}

/// A minimal dummy implementation that provides the properties accessed by
/// [AnalogClock]. The real library expects a `ClockModel` from the
/// `flutter_clock_helper` package; this stub supplies the same API surface
/// needed for the demo to run.
class _DummyClockModel {
  const _DummyClockModel();

  // Temperature string displayed on the clock.
  String get temperatureString => '20°C';

  // Low temperature value.
  int get low => 15;

  // High temperature string.
  String get highString => '25°C';

  // Weather condition string.
  String get weatherString => 'Sunny';

  // Location string.
  String get location => 'Demo Location';
}
