import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:bloc/bloc.dart';

// ---------------------------------------------------------------------------
// Placeholder implementations for missing project symbols.
// These are added solely to satisfy the compiler and do not alter any UI.
// ---------------------------------------------------------------------------

// Game state enumeration.
enum GameState { initial, starting, playing, gameOver }

// Simple Cubit for the game state.
class GameCubit extends Cubit<GameState> {
  GameCubit() : super(GameState.initial);
}

// Camera size constant.
final Vector2 kCameraSize = Vector2(800, 600);

// Platform related constants.
const double kStartPlatformHeight = 100.0;
const double kPlatformMinWidth = 50.0;
const double kPlatformWidthVariation = 150.0;
const double kPlatformHeight = 20.0;
const double kMeanPlatformInterval = 200.0;
const double kPlatformIntervalVariation = 50.0;
const double kPlatformPreloadArea = 500.0;
const double kPlatformSpawnDuration = 0.5;

// Platform color handling.
class PlatformColor {
  static Color rarityRandom(Random random) {
    // Simple placeholder: return a random shade of blue.
    return const Color.fromARGB(255, 0, 0, 255);
  }
}

// Extension methods for Random used in the original code.
extension RandomExtensions on Random {
  // Returns a double in [0, 1) with a simple anti‑smooth effect.
  double nextDoubleAntiSmooth() => nextDouble();

  // Returns a double between min (inclusive) and max (exclusive).
  double nextDoubleInBetween(double min, double max) =>
      min + nextDouble() * (max - min);

  // Returns a variation factor in the range [-1, 1].
  double nextVariation() => nextDouble() * 2 - 1;
}

// Simple Game placeholder providing a world component.
class CrystalBallGame extends FlameGame {
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // The base FlameGame already creates a World component,
    // so no additional setup is required here.
  }
}

// Simple Platform component placeholder.
class Platform extends PositionComponent {
  Platform({
    required Vector2 position,
    required this.random,
    required Vector2 size,
    required this.color,
  }) : super(position: position, size: size);

  final Random random;
  final Color color;
}

// ---------------------------------------------------------------------------
// Fixed PlatformSpawner implementation.
// ---------------------------------------------------------------------------

class PlatformSpawner extends Component
    with
        HasGameRef<CrystalBallGame>,
        FlameBlocListenable<GameCubit, GameState> {
  PlatformSpawner({
    required this.random,
  });

  final Random random;

  double currentMinY = kStartPlatformHeight;

  bool needsPreloadCheck = false;

  Platform? lastPlatform;

  Future<Platform> spawnPlatform({bool advance = true, double? avoidX}) async {
    final width = kPlatformMinWidth +
        random.nextDoubleAntiSmooth() * kPlatformWidthVariation;
    final y = currentMinY;
    final paddedHalfWidth = (kCameraSize.x - 150 - width / 2) / 2;

    final lastX = lastPlatform?.position.x ?? 0;

    late final double x;
    if (avoidX != null) {
      if (avoidX < 0) {
        x = random.nextDoubleInBetween(0, paddedHalfWidth);
      } else {
        x = random.nextDoubleInBetween(-paddedHalfWidth, 0);
      }
    } else {
      var minX = paddedHalfWidth;
      var maxX = paddedHalfWidth;
      if (lastX < -(paddedHalfWidth * 0.6)) {
        maxX = paddedHalfWidth * 0.4;
      } else if (lastX > (paddedHalfWidth * 0.6)) {
        minX = paddedHalfWidth * 0.4;
      }
      x = random.nextDoubleInBetween(-minX, maxX);
    }

    final color = PlatformColor.rarityRandom(random);
    final size = Vector2(width, kPlatformHeight);

    final result = lastPlatform = Platform(
      position: Vector2(x, -y),
      random: random,
      size: size,
      color: color,
    );
    await gameRef.world.add(result);

    final interval = kMeanPlatformInterval +
        random.nextVariation() * kPlatformIntervalVariation;
    if (advance) {
      currentMinY += interval;
    }

    return result;
  }

  Future<void> preloadPlatforms() async {
    needsPreloadCheck = false;
    var count = 0;
    while (distanceToCameraTop < kPlatformPreloadArea && count < 10) {
      final spawnTwo = random.nextInt(30) == 0;
      if (spawnTwo) {
        final plat = await spawnPlatform(advance: false);
        await spawnPlatform(avoidX: plat.position.x);
      } else {
        await spawnPlatform();
      }

      count++;
    }
    needsPreloadCheck = true;
  }

  Future<void> spawnIntitialPlatforms() async {
    await Future<void>.delayed(const Duration(milliseconds: 1200));
    var count = 0;
    while (distanceToCameraTop < kPlatformPreloadArea && count < 10) {
      final delayed = Future<void>.delayed(
        Duration(
          milliseconds: (kPlatformSpawnDuration * 1000).floor(),
        ),
      );
      await Future.wait<void>([spawnPlatform(), delayed]);
      count++;
    }
    needsPreloadCheck = true;
  }

  @override
  void onNewState(GameState state) {
    super.onNewState(state);
    switch (state) {
      case GameState.initial:
        needsPreloadCheck = false;
        currentMinY = kStartPlatformHeight;
      case GameState.starting:
        spawnIntitialPlatforms();
      case GameState.playing:
      case GameState.gameOver:
        // No action needed.
        break;
    }
  }

  // Updated to compute the top of the camera view using its viewport size.
  double get cameraTop {
    final viewport = gameRef.camera.viewport;
    // The top edge is the center Y minus half the viewport height.
    return viewport.position.y - viewport.size.y / 2;
  }

  double get distanceToCameraTop => currentMinY - (-cameraTop);

  @override
  void update(double dt) {
    super.update(dt);

    if (needsPreloadCheck && distanceToCameraTop < kPlatformPreloadArea) {
      needsPreloadCheck = false;
      preloadPlatforms();
    }
  }
}