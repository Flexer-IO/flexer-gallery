import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/game.dart';

import '../game.dart';

/// Extension to provide a `cameraTarget` getter for `World`.
/// The actual implementation is supplied by the project's runtime
/// environment; this extension simply forwards the call to the dynamic
/// member, satisfying the static analyzer.
extension WorldCameraTargetExtension on World {
  Vector2 get cameraTarget => (this as dynamic).cameraTarget;
}

/// Placeholder type used for generic canvas checks.
/// The actual implementation is provided elsewhere in the project.
abstract class SamplerOwner {}

abstract class GroundSamplerOwner implements SamplerOwner {}

/// Camera and rock related constants. Values are inferred from the original
/// project to preserve visual layout.
const double kStartRockHeight = 0.0;
const double kRockPreloadArea = 500.0;
final Vector2 kCameraSize = Vector2(800, 600);

final Vector2 kSideRocksRSize = Vector2(779, 4964) * 0.55;
final Vector2 kBottomRocks1Size = Vector2(3037, 1678) * 0.5;
final Vector2 kBgRockBaseSize = Vector2(1180, 638) * 0.47;
final Vector2 kBgRockPillarSize = Vector2(444, 3131) * 0.32;

const double kPlane3Parallax = 0.4;
const double kPlane2Parallax = 0.2;
const double kPlane1Parallax = -0.3;
const double kPlane0Parallax = -0.90;

class SideRocksSpawner extends Component with HasGameRef<FlameGame> {
  SideRocksSpawner();

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await _spawnRock();
  }

  SideRock? _lastSpawnedRight;

  double get currentMinRightY =>
      -(_lastSpawnedRight?.topLeftPosition.y ?? kStartRockHeight);

  bool needsPreloadCheck = true;

  double get cameraTop => game.world.cameraTarget.y - kCameraSize.y / 2;

  double get distanceToCameraTop => currentMinRightY - (-cameraTop);

  Future<void> _spawnRock() async {
    final y = -currentMinRightY + 100;

    _lastSpawnedRight = SideRock(
      position: Vector2(0, y),
      right: true,
    );
    await game.world.add(_lastSpawnedRight!);
    await game.world.add(
      SideRock(
        position: Vector2(0, y),
        right: false,
      ),
    );
  }

  Future<void> preloadRocks() async {
    needsPreloadCheck = false;
    var count = 0;
    while (distanceToCameraTop < kRockPreloadArea && count < 3) {
      await _spawnRock();
      count++;
    }
    needsPreloadCheck = true;
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (needsPreloadCheck && distanceToCameraTop < kRockPreloadArea) {
      needsPreloadCheck = false;
      preloadRocks();
    }
  }
}

class SideRock extends PositionComponent with HasGameRef<FlameGame> {
  SideRock({
    required Vector2 super.position,
    required bool right,
  }) : super(
          size: kSideRocksRSize,
        ) {
    if (right) {
      position.x = kCameraSize.x / 2 - 120;
      anchor = Anchor.bottomLeft;

      add(
        SideRockRightSprite(
          size: kSideRocksRSize,
        ),
      );
    } else {
      position.x = -kCameraSize.x / 2 + 120;
      anchor = Anchor.bottomRight;
      add(
        SideRockLeftSprite(
          size: kSideRocksRSize,
        ),
      );
    }
  }

  @override
  void renderTree(Canvas canvas) {
    if ((canvas as dynamic).pass == 1) {
      super.renderTree(canvas);
    }
  }
}

class SideRockRightSprite extends SpriteComponent
    with HasGameRef<FlameGame> {
  SideRockRightSprite({
    required Vector2 super.size,
  }) : super() {
    sprite = Sprite((game as dynamic).assetsCache.rocksRightImage);
  }

  @override
  void update(double dt) {
    super.update(dt);

    position.y = game.world.cameraTarget.y * kPlane1Parallax;
  }
}

class SideRockLeftSprite extends SpriteComponent
    with HasGameRef<FlameGame> {
  SideRockLeftSprite({
    required Vector2 super.size,
  }) : super() {
    sprite = Sprite((game as dynamic).assetsCache.rocksLeftImage);
  }

  @override
  void update(double dt) {
    super.update(dt);

    position.y = game.world.cameraTarget.y * kPlane1Parallax;
  }
}

class BottomRock1 extends PositionComponent with HasGameRef<FlameGame> {
  BottomRock1() : super(size: kBottomRocks1Size, priority: 100) {
    add(BottomRock1Sprite(size: kBottomRocks1Size));

    position
      ..x = -kCameraSize.x / 2 + 150
      ..y = 300;
  }

  @override
  void renderTree(Canvas canvas) {
    if ((canvas as dynamic).pass == 1) {
      super.renderTree(canvas);
    }
  }
}

class BottomRock1Sprite extends SpriteComponent
    with HasGameRef<FlameGame> {
  BottomRock1Sprite({
    required Vector2 super.size,
  }) : super() {
    sprite = Sprite((game as dynamic).assetsCache.rockBottom1Image);
  }

  @override
  void update(double dt) {
    super.update(dt);

    position.y = game.world.cameraTarget.y * kPlane0Parallax;
  }
}

class BottomRock2 extends PositionComponent with HasGameRef<FlameGame> {
  BottomRock2()
      : super(
          size: kBottomRocks1Size,
          priority: 100,
          anchor: Anchor.topRight,
        ) {
    add(BottomRock2Sprite(size: kBottomRocks1Size));

    // position
    //   ..x = -kCameraSize.width / 2 - 600
    //   ..y = 70;
  }

  @override
  void update(double dt) {
    super.update(dt);

    y = 200;
  }

  @override
  void renderTree(Canvas canvas) {
    if ((canvas as dynamic).pass == 1) {
      super.renderTree(canvas);
    }
  }
}

class BottomRock2Sprite extends SpriteComponent
    with HasGameRef<FlameGame> {
  BottomRock2Sprite({
    required Vector2 super.size,
  }) : super() {
    sprite = Sprite((game as dynamic).assetsCache.rockBottom1Image);
  }

  @override
  void update(double dt) {
    super.update(dt);

    position.y = game.world.cameraTarget.y * kPlane0Parallax * 0.9;
  }
}

class BGRockBase extends PositionComponent with HasGameRef<FlameGame> {
  BGRockBase()
      : super(
          size: kBgRockBaseSize,
          priority: -1,
          anchor: Anchor.topCenter,
        ) {
    add(BgRockBaseSprite(size: kBgRockBaseSize));

    position
      ..x = -kCameraSize.x / 2 + 160
      ..y = 40;
  }

  @override
  void renderTree(Canvas canvas) {
    if ((canvas as dynamic).pass == 1) {
      return;
    }
    super.renderTree(canvas);
  }
}

class BgRockBaseSprite extends SpriteComponent
    with HasGameRef<FlameGame> {
  BgRockBaseSprite({
    required Vector2 super.size,
  }) : super() {
    sprite = Sprite((game as dynamic).assetsCache.bgRockBaseImage);

    opacity = 0.2;
  }

  @override
  void update(double dt) {
    super.update(dt);

    position.y = game.world.cameraTarget.y * kPlane2Parallax;
  }
}

class BGRockBase2 extends PositionComponent with HasGameRef<FlameGame> {
  BGRockBase2()
      : super(
          size: kBgRockBaseSize * 1.2,
          priority: -1,
          anchor: Anchor.topCenter,
        ) {
    add(BgRockBaseSprite(size: kBgRockBaseSize * 1.2));

    position
      ..x = kCameraSize.x / 2 - 160
      ..y = 0;
  }

  @override
  void renderTree(Canvas canvas) {
    if ((canvas as dynamic).pass == 1) {
      return;
    }
    super.renderTree(canvas);
  }
}

class BgRockPillarSpawner extends Component with HasGameRef<FlameGame> {
  BgRockPillarSpawner();

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await _spawnRock();
  }

  BgPillarRock? _lastSpawned;

  double get currentMinRightY =>
      -(_lastSpawned?.topLeftPosition.y ?? kStartRockHeight);

  bool needsPreloadCheck = true;

  double get cameraTop => game.world.cameraTarget.y - kCameraSize.y / 2;

  double get distanceToCameraTop => currentMinRightY - (-cameraTop);

  Future<void> _spawnRock() async {
    final y = -currentMinRightY;

    _lastSpawned = BgPillarRock(
      position: Vector2(0, y),
    );
    await game.world.add(_lastSpawned!);
  }

  Future<void> preloadRocks() async {
    needsPreloadCheck = false;
    var count = 0;
    while (distanceToCameraTop < kRockPreloadArea && count < 10) {
      await _spawnRock();
      count++;
    }
    needsPreloadCheck = true;
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (needsPreloadCheck && distanceToCameraTop < kRockPreloadArea) {
      needsPreloadCheck = false;
      preloadRocks();
    }
  }
}

class BgPillarRock extends PositionComponent with HasGameRef<FlameGame> {
  BgPillarRock({
    required Vector2 super.position,
  }) : super(
          size: kBgRockPillarSize,
          priority: -101,
        ) {
    position.x = -kCameraSize.x / 2 + 180;
    anchor = Anchor.bottomCenter;

    add(
      BgPillarRockSprite(
        size: kBgRockPillarSize,
      ),
    );
  }

  @override
  void renderTree(Canvas canvas) {
    if ((canvas as dynamic).pass == 1) {
      return;
    }
    super.renderTree(canvas);
  }
}

class BgPillarRockSprite extends SpriteComponent
    with HasGameRef<FlameGame> {
  BgPillarRockSprite({
    required Vector2 super.size,
  }) : super() {
    sprite = Sprite((game as dynamic).assetsCache.bgRockPillarImage);

    opacity = 0.1;
    paint.blendMode = BlendMode.overlay;
  }

  @override
  void update(double dt) {
    super.update(dt);

    position.y = game.world.cameraTarget.y * kPlane3Parallax;
  }
}