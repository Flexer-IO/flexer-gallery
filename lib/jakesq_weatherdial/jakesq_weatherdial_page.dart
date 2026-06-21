import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/model.dart';
import '../analog_clock.dart';

class JakesqWeatherdialPage extends StatefulWidget {
  const JakesqWeatherdialPage({super.key});

  @override
  State<JakesqWeatherdialPage> createState() => _JakesqWeatherdialPageState();
}

class _JakesqWeatherdialPageState extends State<JakesqWeatherdialPage> {
  late final ClockModel _model;

  @override
  void initState() {
    super.initState();
    _model = ClockModel();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnalogClock(_model),
    );
  }
}
