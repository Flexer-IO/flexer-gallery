import 'package:flutter/material.dart';
import '../analog_clock.dart';

/// A minimal stub implementation of the [ClockModel] expected by the
/// original library. It provides the properties accessed by [AnalogClock].
class ClockModel extends ChangeNotifier {
  String get temperatureString => '0°C';
  String get low => '0';
  String get highString => '0°C';
  String get weatherString => 'Clear';
  String get location => 'Nowhere';
}

/// A thin wrapper page that displays the original analog clock widget
/// from the library. No additional UI is introduced.
class MeszarosdezsoFlutterClockPage extends StatelessWidget {
  const MeszarosdezsoFlutterClockPage({super.key});

  static final ClockModel _model = ClockModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnalogClock(_model),
    );
  }
}
