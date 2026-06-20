import 'package:flutter/material.dart';
import 'deps/flame/game.dart';
import '../main.dart';

class MboonchaiDaPixelPage extends StatelessWidget {
  const MboonchaiDaPixelPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameWidget(game: DaPixel()),
    );
  }
}
