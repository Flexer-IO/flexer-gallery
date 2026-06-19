import 'package:flutter/material.dart';
import '../deps/flutter_clock_helper/ants_clock.dart';
import '../deps/flutter_clock_helper/model.dart';

class StuartappFlutterClockChallengePage extends StatefulWidget {
  const StuartappFlutterClockChallengePage({super.key});

  @override
  State<StuartappFlutterClockChallengePage> createState() =>
      _StuartappFlutterClockChallengePageState();
}

class _StuartappFlutterClockChallengePageState
    extends State<StuartappFlutterClockChallengePage> {
  late final ClockModel _model;

  @override
  void initState() {
    super.initState();
    _model = ClockModel();
    _model.addListener(_onTick);
  }

  void _onTick() {
    setState(() {});
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AntsClock(_model),
    );
  }
}