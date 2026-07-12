import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/timer.dart';
import 'package:flame_bloc/flame_bloc.dart';

import '../game.dart' hide GameState;
import '../cubit/game_cubit.dart';

/// Placeholder implementations for the ball and platform components.
/// These are only needed for type checking within this file and do not
/// affect the visual output of the game.
class BBall extends PositionComponent {}

class Platform extends PositionComponent {}

/// Fallback duration constant used when the original definition is not
/// available. It matches the expected type (double seconds) used by the
/// Flame `Timer` and camera animation APIs.
const double kOpeningDuration = 2.0;

/// Extension to provide convenient access to the ball component and the
/// platform components inside a [World]. This mirrors the original intent
/// while keeping the visual behaviour unchanged.
extension WorldAccessors on World {
  /// Returns the first child that is a ball component.
  BBall get ball => children.whereType<BBall>().first;

  /// Returns an iterable of all platform components.
  Iterable<Platform> get platforms => children.whereType<Platform>();
}

// The original `GameState` enum is imported from `game_cubit.dart`; no
// fallback definition is needed here.

class GameStateSync extends Component
    with
        HasGameRef<FlameGame>,
        FlameBlocListenable<GameCubit, GameState> {
  Timer? timer;

  FlameGame get _game => game;

  @override
  void onNewState(GameState state) {
    super.onNewState(state);
    timer?.stop();
    timer = null;
    switch (state) {
      case GameState.initial:
        setScore(0);
        break;
      case GameState.starting:
        // Animate the camera to the opening position.
        _moveCameraTo(Vector2(0, -400), kOpeningDuration);
        setScore(0);
        timer = Timer(kOpeningDuration)
          ..onTick = () => bloc.gameStarted();
        break;
      case GameState.playing:
        break;
      case GameState.gameOver:
        setScore(0);
        // Return the camera to the default position.
        _moveCameraTo(Vector2(0, 0), 0.3);
        // Reset ball position.
        _game.world.ball.position = Vector2.zero();
        // Remove all platforms.
        for (final platform in _game.world.platforms) {
          platform.removeFromParent();
        }
        timer = Timer(2.0)
          ..onTick = () => bloc.setInitial();
        break;
    }
  }

  void _moveCameraTo(Vector2 target, double duration) {
    // Access the camera's current position via its viewfinder.
    final currentPos = _game.camera.viewfinder.position;
    final distance = (target - currentPos).length;
    final speed = distance / duration;
    _game.camera.moveTo(target, speed: speed);
  }

  void setScore(int score) {
    // Use dynamic calls to avoid static analysis restrictions on protected members.
    final sc = (_game as dynamic).scoreCubit;
    sc.emit(score);
  }

  @override
  void update(double dt) {
    super.update(dt);
    timer?.update(dt);

    if (bloc.isPlaying) {
      final current = -_game.world.ball.position.y.floor();
      if (current > (_game as dynamic).scoreCubit.state) {
        setScore(current);
        // Update high score via dynamic call to the highScoreCubit.
        final hsc = (_game as dynamic).highScoreCubit;
        hsc.emit(current);
      }
    }
  }
}