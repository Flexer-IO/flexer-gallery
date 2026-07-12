import '../game.dart';
import '../cubit/game_cubit.dart' as game_cubit;
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/services.dart';

class InputHandler extends PositionComponent
    with TapCallbacks, HasGameRef<CrystalBallGame> {
  InputHandler()
      : super(
          anchor: Anchor.center,
          size: Vector2(kCameraSize.$1, kCameraSize.$2),
        );

  // Helper getter to access the concrete game type safely.
  CrystalBallGame get _game => game;

  @override
  Future<void> onLoad() async {
    await add(
      KeyboardListenerComponent(
        keyDown: {
          LogicalKeyboardKey.space: onSpace,
        },
      ),
    );

    await add(
      KeyboardListenerComponent(
        keyDown: {
          LogicalKeyboardKey.arrowLeft: onLeftStart,
          LogicalKeyboardKey.arrowRight: onRightStart,
        },
        keyUp: {
          LogicalKeyboardKey.arrowLeft: onLeftEnd,
          LogicalKeyboardKey.arrowRight: onRightEnd,
        },
      ),
    );

    return super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
    // `cameraTarget` is a Vector2, so assign it directly.
    position = _game.world.cameraTarget;
  }

  bool onSpace(Set<LogicalKeyboardKey> logicalKeys) {
    if (_game.gameCubit.state == game_cubit.GameState.initial) {
      // ignore: avoid_dynamic_calls
      (_game.gameCubit as dynamic).start();
      return false;
    }
    return true;
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);

    if (event.devicePosition.x < _game.size.x / 2) {
      onLeftStart({});
    } else {
      onRightStart({});
    }
  }

  @override
  void onTapUp(TapUpEvent event) {
    super.onTapUp(event);
    if (_game.gameCubit.state == game_cubit.GameState.initial) {
      // ignore: avoid_dynamic_calls
      (_game.gameCubit as dynamic).start();
    }
    if (!(_game.gameCubit.state == game_cubit.GameState.playing)) return;
    if (event.devicePosition.x < _game.size.x / 2) {
      onLeftEnd({});
    } else {
      onRightEnd({});
    }
  }

  double _directionalCoefficient = 0;

  double get directionalCoefficient => _directionalCoefficient;

  bool onLeftStart(Set<LogicalKeyboardKey> logicalKeys) {
    if (!(_game.gameCubit.state == game_cubit.GameState.playing)) return true;
    _directionalCoefficient = -1;
    return false;
  }

  bool onRightStart(Set<LogicalKeyboardKey> logicalKeys) {
    if (!(_game.gameCubit.state == game_cubit.GameState.playing)) return true;
    _directionalCoefficient = 1;
    return false;
  }

  bool onLeftEnd(Set<LogicalKeyboardKey> logicalKeys) {
    if (!(_game.gameCubit.state == game_cubit.GameState.playing)) return true;
    if (_directionalCoefficient < 0) {
      _directionalCoefficient = 0;
    }
    return false;
  }

  bool onRightEnd(Set<LogicalKeyboardKey> logicalKeys) {
    if (!(_game.gameCubit.state == game_cubit.GameState.playing)) return true;
    if (_directionalCoefficient > 0) {
      _directionalCoefficient = 0;
    }
    return false;
  }
}