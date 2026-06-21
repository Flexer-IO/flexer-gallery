import 'package:flutter/material.dart';
import 'customizer.dart';
import 'model.dart';

class IlikerobotsRetrosfClockPage extends StatelessWidget {
  const IlikerobotsRetrosfClockPage({super.key});

  static Widget _clockBuilder(ClockModel model) {
    // Minimal placeholder using the provided model.
    // This satisfies the required ClockBuilder signature without adding
    // custom UI beyond the library's own wrapper.
    return Center(
      child: Text(
        'Clock placeholder',
        style: const TextStyle(fontSize: 24),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ClockCustomizer(_clockBuilder),
    );
  }
}
