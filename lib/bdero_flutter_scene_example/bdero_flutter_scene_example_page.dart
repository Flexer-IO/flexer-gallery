import 'package:flutter/material.dart';
import '../demo/game.dart';

class BderoFlutterSceneExamplePage extends StatelessWidget {
  const BderoFlutterSceneExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameWidget(),
    );
  }
}
