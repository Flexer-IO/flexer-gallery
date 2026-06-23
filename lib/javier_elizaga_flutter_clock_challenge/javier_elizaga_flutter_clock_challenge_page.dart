import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/model.dart';

import 'digital_clock.dart';

class JavierElizagaFlutterClockChallengePage extends StatefulWidget {
  const JavierElizagaFlutterClockChallengePage({super.key});

  @override
  State<JavierElizagaFlutterClockChallengePage> createState() =>
      _JavierElizagaFlutterClockChallengePageState();
}

class _JavierElizagaFlutterClockChallengePageState
    extends State<JavierElizagaFlutterClockChallengePage> {
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
      body: DigitalClock(_model),
    );
  }
}
