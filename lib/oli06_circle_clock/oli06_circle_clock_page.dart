import 'package:flutter/material.dart';
import 'date_widget.dart';

class Oli06CircleClockPage extends StatelessWidget {
  const Oli06CircleClockPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double diameter = size.width * 0.8;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Circle Clock'),
      ),
      body: Center(
        child: DateWidget(
          date: DateTime.now(),
          height: diameter,
          width: diameter,
          textColor: Colors.white,
          circleColor: Colors.blue,
        ),
      ),
    );
  }
}
