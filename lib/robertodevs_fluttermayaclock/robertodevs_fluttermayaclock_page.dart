import 'package:flutter/material.dart';
import 'customizer.dart';
import 'model.dart';

class RobertodevsFluttermayaclockPage extends StatelessWidget {
  const RobertodevsFluttermayaclockPage({super.key});

  @override
  Widget build(BuildContext context) {
    // The library expects a ClockBuilder that receives a ClockModel.
    // We provide a minimal placeholder widget that satisfies the type.
    Widget clockBuilder(ClockModel model) {
      return Container(
        color: Colors.black,
        alignment: Alignment.center,
        child: const Text(
          'Clock',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      );
    }

    return Scaffold(
      body: ClockCustomizer(clockBuilder),
    );
  }
}
