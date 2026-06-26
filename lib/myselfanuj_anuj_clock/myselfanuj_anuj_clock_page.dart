import 'package:flutter/material.dart';
import 'package:myselfanuj_anuj_clock/anj_clock.dart';

class MyselfanujAnujClockPage extends StatelessWidget {
  const MyselfanujAnujClockPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Anuj Clock'),
        backgroundColor: Colors.deepOrange,
      ),
      body: Center(
        child: AnujClock(),
      ),
    );
  }
}