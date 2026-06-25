import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../analog_clock.dart';

class SalibhdrTyphoonFlutterClockPage extends StatefulWidget {
  const SalibhdrTyphoonFlutterClockPage({super.key});

  @override
  State<SalibhdrTyphoonFlutterClockPage> createState() =>
      _SalibhdrTyphoonFlutterClockPageState();
}

class _SalibhdrTyphoonFlutterClockPageState
    extends State<SalibhdrTyphoonFlutterClockPage> {
  late final _FakeClockModel _model;

  @override
  void initState() {
    super.initState();
    _model = _FakeClockModel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnalogClock(_model),
      ),
    );
  }
}

/// A minimal stub that mimics the API of `ClockModel` used by the library.
class _FakeClockModel {
  final List<VoidCallback> _listeners = <VoidCallback>[];

  // Temperature string shown on the clock.
  String get temperatureString => '25°C';

  // Low temperature value (used for the range display).
  double get low => 20.0;

  // High temperature string.
  String get highString => '30°C';

  // Weather description.
  String get weatherString => 'Sunny';

  // Location name.
  String get location => 'Nowhere';

  void addListener(VoidCallback listener) => _listeners.add(listener);

  void removeListener(VoidCallback listener) => _listeners.remove(listener);
}
