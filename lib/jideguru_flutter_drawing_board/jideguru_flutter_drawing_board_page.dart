import 'package:flutter/material.dart';
import 'src/presentation/pages/drawing_page.dart';

class JideguruFlutterDrawingBoardPage extends StatelessWidget {
  const JideguruFlutterDrawingBoardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Drawing Board'),
      ),
      body: const DrawingPage(),
    );
  }
}