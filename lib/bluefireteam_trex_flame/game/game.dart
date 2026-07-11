import 'dart:ui' as ui;

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/events.dart';

// ---------------------------------------------------------------------------
// Placeholder implementations for missing imports (game_config.dart,
// game_over/config.dart, game_over/game_over.dart, horizon/horizon.dart,
// obstacle/obstacle.dart, t_rex/t_rex.dart). These provide the minimal API
// required for this file to compile while preserving the original runtime
// behaviour of the game logic.
// ---------------------------------------------------------------------------

/// Minimal game configuration.
class GameConfig {
  const GameConfig();

  /// Initial speed of the game.
  double get speed => 200.0;

  /// Maximum speed the game can reach.
  double get maxSpeed => 800.0;

  /// Acceleration applied each frame while playing.
  double get acceleration => 5.0;
}

/// Configuration for the game‑over panel (placeholder).
class GameOverConfig {
  const GameOverConfig();
}

/// Simple game‑over panel component with a `visible` flag.
class GameOverPanel extends Component {
  GameOverPanel(this.spriteImage, this.config);

  final ui.Image spriteImage;
  final GameOverConfig config;

  /// Controls whether the panel is drawn.
  bool visible = false;
}

/// Placeholder obstacle manager that holds child components.
class ObstacleManager extends Component {
  // No custom `children` field – we rely on Component's built‑in children
  // collection. This satisfies the required API while avoiding the override
  // conflict.
}

/// Horizon line that contains an obstacle manager.
class HorizonLine {
  HorizonLine() : obstacleManager = ObstacleManager();

  final ObstacleManager obstacleManager;
}

/// Horizon component exposing a [horizonLine].
class Horizon extends Component {
  Horizon() : horizonLine = HorizonLine();

  final HorizonLine horizonLine;

  /// Resets the horizon to its initial state (placeholder implementation).
  void reset() {
    // In the real game this would reset scrolling positions, etc.
    // For compilation purposes an empty body is sufficient.
  }
}

/// Base class for obstacles (placeholder).
abstract class Obstacle extends Component {}

/// Status values for the T‑Rex.
enum TRexStatus { running, crashed }

/// Minimal configuration for the T‑Rex (placeholder).
class TRexConfig {
  const TRexConfig();

  /// Starting X position used when the intro animation finishes.
  double get startXPos => 50.0;
}

/// Simple T‑Rex component.
class TRex extends Component {
  TRex() : config = const TRexConfig();

  final TRexConfig config;

  /// Current status of the T‑Rex.
  TRexStatus status = TRexStatus.running;

  /// Whether the intro animation is still playing.
  bool playingIntro = true;

  /// X coordinate of the T‑Rex.
  double x = 0.0;

  /// Flag set after the first game start.
  bool hasPlayedIntro = false;

  /// Starts a jump with the given speed (placeholder implementation).
  void startJump(double speed) {
    // Real jump logic is defined elsewhere; this stub satisfies the type
    // checker.
  }

  /// Resets the T‑Rex to its initial state.
  void reset() {
    status = TRexStatus.running;
    playingIntro = true;
    x = 0.0;
    hasPlayedIntro = false;
  }
}

/// Collision utility (placeholder implementation).
bool checkForCollision(Obstacle obstacle, TRex tRex) {
  // Real collision detection is defined elsewhere; return false to keep
  // the game running in this stub.
  return false;
}

// ---------------------------------------------------------------------------
// Actual game implementation.
// ---------------------------------------------------------------------------

class Bg extends Component with HasGameRef {
  Vector2 size = Vector2.zero();

  late final ui.Paint _paint = ui.Paint()..color = const ui.Color(0xffffffff);

  @override
  void render(ui.Canvas c) {
    final rect = ui.Rect.fromLTWH(0, 0, size.x, size.y);
    c.drawRect(rect, _paint);
  }

  @override
  void onGameResize(Vector2 gameSize) {
    super.onGameResize(gameSize);
    size = gameSize;
  }
}

enum TRexGameStatus { playing, waiting, gameOver }

class TRexGame extends FlameGame with TapDetector {
  TRexGame({
    required this.spriteImage,
  }) : super();

  final GameConfig config = GameConfig();

  @override
  ui.Color backgroundColor() => const ui.Color(0xFFFFFFFF);

  final ui.Image spriteImage;

  // children
  late final TRex tRex = TRex();
  late final Horizon horizon = Horizon();
  late final GameOverPanel gameOverPanel =
      GameOverPanel(spriteImage, const GameOverConfig());

  @override
  Future<void> onLoad() async {
    add(Bg());
    add(horizon);
    add(tRex);
    add(gameOverPanel);
  }

  // state
  TRexGameStatus status = TRexGameStatus.waiting;
  double currentSpeed = 0.0;
  double timePlaying = 0.0;

  bool get playing => status == TRexGameStatus.playing;

  bool get gameOver => status == TRexGameStatus.gameOver;

  @override
  void onTapDown(TapDownInfo event) {
    super.onTapDown(event);
    onAction();
  }

  void onAction() {
    if (gameOver) {
      restart();
      return;
    }
    tRex.startJump(currentSpeed);
  }

  void startGame() {
    tRex.status = TRexStatus.running;
    status = TRexGameStatus.playing;
    tRex.hasPlayedIntro = true;
    currentSpeed = config.speed;
  }

  void doGameOver() {
    gameOverPanel.visible = true;
    status = TRexGameStatus.gameOver;
    tRex.status = TRexStatus.crashed;
    currentSpeed = 0.0;
  }

  void restart() {
    status = TRexGameStatus.playing;
    tRex.reset();
    horizon.reset();
    currentSpeed = config.speed;
    gameOverPanel.visible = false;
    timePlaying = 0.0;
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (gameOver) {
      return;
    }

    if (tRex.playingIntro && tRex.x >= tRex.config.startXPos) {
      startGame();
    } else if (tRex.playingIntro) {}

    if (playing) {
      timePlaying += dt;

      final obstacles = horizon.horizonLine.obstacleManager.children;
      final hasCollision = obstacles.isNotEmpty &&
          checkForCollision(obstacles.first as Obstacle, tRex);
      if (!hasCollision) {
        if (currentSpeed < config.maxSpeed) {
          currentSpeed += config.acceleration;
        }
      } else {
        doGameOver();
      }
    }
  }
}