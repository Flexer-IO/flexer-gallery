import 'package:flutter/material.dart';
import 'deps/flame/game.dart';
import '../flutters-game.dart';

class EcklfFluttersPage extends StatelessWidget {
  const EcklfFluttersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final game = FluttersGame(MediaQuery.of(context).size);
    return Scaffold(
      body: GameWidget(game: game),
    );
  }
}
