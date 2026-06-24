import 'package:flutter/material.dart';
import 'package:vanethos_flutter_interact_clock/vanethos_flutter_interact_clock.dart';

class VanethosFlutterInteractClockPage extends StatelessWidget {
  const VanethosFlutterInteractClockPage({super.key});

  @override
  Widget build(BuildContext context) {
    // The library's main entry widget is InteractClock.
    // It is returned directly as the page content.
    return InteractClock();
  }
}