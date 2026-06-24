import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/model.dart';
import 'bike_clock.dart';

class DshukertjrBikeClockPage extends StatefulWidget {
  const DshukertjrBikeClockPage({super.key});

  @override
  State<DshukertjrBikeClockPage> createState() => _DshukertjrBikeClockPageState();
}

class _DshukertjrBikeClockPageState extends State<DshukertjrBikeClockPage> {
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
    return BikeClock(_model);
  }
}
