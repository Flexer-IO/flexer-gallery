import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/model.dart';
import '../analog_clock.dart';

class RocktyphoonTyphoonClockPage extends StatefulWidget {
  const RocktyphoonTyphoonClockPage({super.key});

  @override
  State<RocktyphoonTyphoonClockPage> createState() =>
      _RocktyphoonTyphoonClockPageState();
}

class _RocktyphoonTyphoonClockPageState
    extends State<RocktyphoonTyphoonClockPage> {
  late final ClockModel _model;

  @override
  void initState() {
    super.initState();
    _model = ClockModel();
  }

  @override
  void dispose() {
    // If ClockModel implements dispose, call it; otherwise ignore.
    try {
      _model.dispose();
    } catch (_) {}
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnalogClock(_model),
    );
  }
}
