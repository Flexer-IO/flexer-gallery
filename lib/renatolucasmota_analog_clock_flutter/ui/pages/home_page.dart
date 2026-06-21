import 'package:flutter/material.dart';
import 'package:renatolucasmota_analog_clock_flutter/ui/clock_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'The Clock',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.black) ??
              const TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: ClockView()),
        ],
      ),
    );
  }
}