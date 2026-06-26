import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/model.dart';

import '../components/fantasy_clock.dart';

class CodehipsterFlutterFantasyClockPage extends StatefulWidget {
  const CodehipsterFlutterFantasyClockPage({super.key});

  @override
  State<CodehipsterFlutterFantasyClockPage> createState() =>
      _CodehipsterFlutterFantasyClockPageState();
}

class _CodehipsterFlutterFantasyClockPageState
    extends State<CodehipsterFlutterFantasyClockPage> {
  late final ClockModel _clockModel;

  @override
  void initState() {
    super.initState();
    _clockModel = ClockModel();
  }

  @override
  void dispose() {
    _clockModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FantasyClock(_clockModel),
    );
  }
}
