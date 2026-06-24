import 'package:flutter/material.dart';
import '../analog_clock.dart';

/// A thin wrapper page that displays the original Analog Clock library.
///
/// This page creates a minimal dummy model to satisfy the [AnalogClock] widget
/// requirements without pulling in external dependencies.
class Ashirshaikh99FlutterClockChallengePage extends StatelessWidget {
  const Ashirshaikh99FlutterClockChallengePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const _ClockWrapper(),
    );
  }
}

/// Internal widget that holds a dummy model and passes it to [AnalogClock].
class _ClockWrapper extends StatefulWidget {
  const _ClockWrapper({Key? key}) : super(key: key);

  @override
  State<_ClockWrapper> createState() => _ClockWrapperState();
}

class _ClockWrapperState extends State<_ClockWrapper> {
  late final dynamic _dummyModel;

  @override
  void initState() {
    super.initState();
    _dummyModel = _DummyModel();
  }

  @override
  Widget build(BuildContext context) {
    // The AnalogClock constructor expects a ClockModel. Using a dynamic
    // instance bypasses static type checking while providing the required
    // members at runtime.
    return AnalogClock(_dummyModel);
  }
}

/// A minimal implementation that mimics the public API of the original
/// [ClockModel] used by the library. Only the members accessed by
/// [AnalogClock] are provided.
class _DummyModel {
  final List<VoidCallback> _listeners = [];

  void addListener(VoidCallback listener) => _listeners.add(listener);
  void removeListener(VoidCallback listener) => _listeners.remove(listener);

  // The following getters are accessed by the original AnalogClock widget.
  String get temperatureString => '';
  String get temperatureRangeString => '';
  String get conditionString => '';
  String get locationString => '';
  String get weatherString => '';
  String get timeZoneString => '';
  bool get is24HourFormat => false;
}
