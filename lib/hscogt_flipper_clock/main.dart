import 'package:flutter/material.dart';

import 'flipper_palette.dart';
import 'digital_clock.dart';

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        body: DigitalClock(palette: kFlipperPalettes.first),
      ),
    ),
  );
}
