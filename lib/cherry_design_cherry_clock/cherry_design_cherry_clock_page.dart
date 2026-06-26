import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/model.dart';
import '../cherry_clock.dart';

class CherryDesignCherryClockPage extends StatelessWidget {
  const CherryDesignCherryClockPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CherryClock(ClockModel()),
    );
  }
}
