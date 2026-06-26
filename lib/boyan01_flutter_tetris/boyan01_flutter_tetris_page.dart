import 'package:flutter/material.dart';
import '../gamer/gamer.dart';
import '../gamer/keyboard.dart';
import '../material/audios.dart';
import '../panel/page_land.dart';
import '../panel/page_portrait.dart';

class Boyan01FlutterTetrisPage extends StatelessWidget {
  const Boyan01FlutterTetrisPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Sound(
        child: Game(
          child: KeyboardController(
            child: Builder(
              builder: (context) {
                final isLandscape =
                    MediaQuery.of(context).orientation == Orientation.landscape;
                return isLandscape ? const PageLand() : const PagePortrait();
              },
            ),
          ),
        ),
      ),
    );
  }
}
