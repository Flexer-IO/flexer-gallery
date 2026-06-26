import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/model.dart';
import '../achintya_clock.dart';

class Chinster99FlutterClockPage extends StatefulWidget {
  const Chinster99FlutterClockPage({super.key});

  @override
  State<Chinster99FlutterClockPage> createState() => _Chinster99FlutterClockPageState();
}

class _Chinster99FlutterClockPageState extends State<Chinster99FlutterClockPage> {
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
      body: AchintyaClock(_clockModel),
    );
  }
}
