import 'package:flutter/material.dart';
import '../analog_clock.dart';

class TalamaskaFlutterClockPage extends StatefulWidget {
  const TalamaskaFlutterClockPage({super.key});

  @override
  State<TalamaskaFlutterClockPage> createState() =>
      _TalamaskaFlutterClockPageState();
}

class _TalamaskaFlutterClockPageState extends State<TalamaskaFlutterClockPage> {
  late final ClockModel _model;

  @override
  void initState() {
    super.initState();
    _model = ClockModel();
  }

  @override
  void dispose() {
    // ClockModel extends ChangeNotifier, so disposing is safe.
    _model.dispose();
    super.dispose();
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
