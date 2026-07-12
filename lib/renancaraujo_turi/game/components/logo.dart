import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/game.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/animation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final kLogoSize = Vector2(1001, 547);

final logoAr = kLogoSize.x / kLogoSize.y;

/// Minimal definition of the game states used by this component.
/// This mirrors the enum defined in the main game file.
enum GameState { initial, starting, playing, gameOver }

class LogoComponent extends SpriteComponent
    with
        HasGameRef<FlameGame>,
        FlameBlocListenable<BlocBase<GameState>, GameState> {
  LogoComponent() : super(anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // Access assetsCache via dynamic to keep compatibility with the specific game type.
    sprite = Sprite((game as dynamic).assetsCache.logoImage);

    // Use the game's camera viewport width instead of the undefined kCameraSize.
    final w = game.camera.viewport.size.x * 0.6;

    paint.blendMode = BlendMode.lighten;

    size = Vector2(w, w / logoAr);
  }

  final effectController = CurvedEffectController(
    3,
    Curves.easeInOut,
  );

  OpacityEffect? _opacityEffect;

  @override
  void onNewState(GameState state) {
    effectController.setToStart();
    _opacityEffect?.removeFromParent();
    switch (state) {
      case GameState.initial:
        add(_opacityEffect = OpacityEffect.fadeIn(effectController));
      case GameState.starting:
        add(_opacityEffect = OpacityEffect.fadeOut(effectController));
      case GameState.playing:
      case GameState.gameOver:
        // No opacity change needed.
        break;
    }
  }

  @override
  void renderTree(Canvas canvas) {
    // Preserve original behavior: skip rendering on the first pass when using a SamplerCanvas.
    // Since the specific SamplerCanvas type may not be available, we perform a dynamic check.
    try {
      if ((canvas as dynamic).pass == 1) {
        return;
      }
    } catch (_) {
      // If the canvas does not have a 'pass' property, continue normally.
    }
    super.renderTree(canvas);
  }
}