import 'package:flutter/material.dart';
import 'package:jg_l_flutter_hex_clock/jg_l_flutter_hex_clock/hex_clock.dart';

class JgLFlutterHexClockPage extends StatelessWidget {
  const JgLFlutterHexClockPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        PageBG(),
        SimpleClock(),
      ],
    );
  }
}