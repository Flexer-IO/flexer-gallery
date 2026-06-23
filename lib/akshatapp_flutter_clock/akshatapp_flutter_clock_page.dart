import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/model.dart';
import '../app.dart';

class AkshatappFlutterClockPage extends StatelessWidget {
  const AkshatappFlutterClockPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppClock(ClockModel());
  }
}
