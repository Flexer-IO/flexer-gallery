import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'dart:ui' as ui;

/// Minimal placeholder implementation of the TRexGame.
/// This class satisfies the compile‑time requirements without altering
/// any UI or rendering logic.
class TRexGame extends FlameGame {
  final ui.Image spriteImage;

  TRexGame({required this.spriteImage});

  /// Called when the user presses Enter or Space.
  void onAction() {
    // Placeholder: actual game logic would go here.
  }
}

class BluefireteamTrexFlamePage extends StatefulWidget {
  const BluefireteamTrexFlamePage({super.key});

  @override
  State<BluefireteamTrexFlamePage> createState() =>
      _BluefireteamTrexFlamePageState();
}

class _BluefireteamTrexFlamePageState extends State<BluefireteamTrexFlamePage> {
  TRexGame? _game;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _loadAssetsAndStartGame();
  }

  Future<void> _loadAssetsAndStartGame() async {
    final images = await Flame.images.loadAll(['sprite.png']);
    setState(() {
      _game = TRexGame(spriteImage: images[0]);
      // Request focus after the widget tree has been built.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _focusNode.requestFocus();
        }
      });
    });
  }

  void _onRawKeyEvent(RawKeyEvent event) {
    if (_game == null) return;
    if (event.logicalKey == LogicalKeyboardKey.enter ||
        event.logicalKey == LogicalKeyboardKey.space) {
      _game!.onAction();
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_game == null) {
      return const Center(child: Text('Loading'));
    }

    return Container(
      color: Colors.white,
      constraints: const BoxConstraints.expand(),
      child: RawKeyboardListener(
        focusNode: _focusNode,
        onKey: _onRawKeyEvent,
        child: GameWidget(game: _game!),
      ),
    );
  }
}