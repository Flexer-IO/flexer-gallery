import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/model.dart';

import 'digital_clock.dart';

class DwiteSceneryFlutterclockPage extends StatelessWidget {
  const DwiteSceneryFlutterclockPage({super.key});

  @override
  Widget build(BuildContext context) {
    // The library's main entry widget is DigitalClock, which requires a ClockModel.
    // We instantiate a default ClockModel and pass it directly.
    return Scaffold(
      body: DigitalClock(ClockModel()),
    );
  }
}
