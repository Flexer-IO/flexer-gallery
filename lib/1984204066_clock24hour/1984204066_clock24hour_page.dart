import 'package:flutter/material.dart';
import 'bubble.dart';

class Clock24hourPage extends StatelessWidget {
  const Clock24hourPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: BobblePage(),
      ),
    );
  }
}