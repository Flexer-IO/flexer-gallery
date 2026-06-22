import 'package:flutter/material.dart';
import 'customizer.dart';
import 'package:thayesx_freehand_clock/freehand_clock.dart';

/// A minimal stub of the ClockModel class originally provided by the
/// `flutter_clock_helper` package. This definition includes only the members
/// that are required for the `FreehandClock` widget used in this page. If the
/// original package is added later, this stub will be ignored because the real
/// class will take precedence.
class ClockModel {
  /// The current date and time.
  final DateTime datetime;

  /// Whether the clock should use a 24‑hour format.
  final bool is24HourFormat;

  const ClockModel({
    required this.datetime,
    required this.is24HourFormat,
  });
}

class ThayesxFreehandClockPage extends StatelessWidget {
  const ThayesxFreehandClockPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ClockCustomizer(
      (ClockModel model) => FreehandClock(model),
    );
  }
}