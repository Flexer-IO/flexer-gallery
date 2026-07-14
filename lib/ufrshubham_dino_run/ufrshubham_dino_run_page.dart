import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'game/dino_run.dart';

class UfrshubhamDinoRunPage extends StatelessWidget {
  const UfrshubhamDinoRunPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameWidget<DinoRun>(
        game: DinoRun(),
      ),
    );
  }
}