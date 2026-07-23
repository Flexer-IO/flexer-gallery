import 'package:flutter/material.dart';
import 'progress_button/reveal_progress_button.dart';

class IhorklimovFlutterprogressbuttonPage extends StatelessWidget {
  const IhorklimovFlutterprogressbuttonPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Progress Button'),
      ),
      body: Center(
        child: RevealProgressButton(),
      ),
    );
  }
}