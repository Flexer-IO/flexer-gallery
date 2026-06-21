import 'package:flutter/material.dart';
import 'count_by_clock.dart';

class MetowhidCountByClockPage extends StatelessWidget {
  const MetowhidCountByClockPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Count By Clock'),
      ),
      body: Center(
        child: CountByClock(
          123,
          digitCount: 3,
        ),
      ),
    );
  }
}