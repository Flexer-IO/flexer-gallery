import 'package:flutter/material.dart';

// Fallback implementation for QlockTwo widget.
// This stub provides the same constructor signature as the original package widget.
class QlockTwo extends StatelessWidget {
  final double fontSize;
  final Color color;

  const QlockTwo({
    Key? key,
    required this.fontSize,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Simple placeholder rendering that mimics the original widget's appearance.
    // It displays the current time in the specified font size and color.
    final time = TimeOfDay.now().format(context);
    return Text(
      time,
      style: TextStyle(
        fontSize: fontSize,
        color: color,
      ),
    );
  }
}

class BirjuvachhaniQlocktwoPage extends StatelessWidget {
  const BirjuvachhaniQlocktwoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: QlockTwo(
          fontSize: 32,
          color: Colors.white,
        ),
      ),
    );
  }
}