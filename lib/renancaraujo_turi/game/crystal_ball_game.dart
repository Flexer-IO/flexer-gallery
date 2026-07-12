import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart' show FlutterError, FlutterErrorDetails;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:flame/components.dart';
import 'package:flame/components.dart' as flame;
import 'package:flame/effects.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/camera.dart';

// ignore_for_file: const_constructor_with_non_const_fields

// -----------------------------------------------------------------------------
// Placeholder implementations for missing project files.
// -----------------------------------------------------------------------------
// Sampler owner hierarchy.
abstract class SamplerOwner {}

class GroundSamplerOwner implements SamplerOwner {
  GroundSamplerOwner({
    required this.groundShader,
    required this.rocksShader,
    required this.fogShader,
    required this.classicCamera,
    required this.provider,
  });

  final FragmentShader groundShader;
  final FragmentShader rocksShader;
  final FragmentShader fogShader;
  final CameraComponent classicCamera;
  final PositionProvider provider;
}

class FogSamplerOwner implements SamplerOwner {
  FogSamplerOwner({
    required this.fogShader,
    required this.provider,
  });

  final FragmentShader fogShader;
  final PositionProvider provider;
}

class PlatformsSamplerOwner implements SamplerOwner {
  PlatformsSamplerOwner({
    required this.platformsShader,
    required this.provider,
  });

  final FragmentShader platformsShader;
  final PositionProvider provider;
}

class TheBallSamplerOwner implements SamplerOwner {
  TheBallSamplerOwner({
    required this.theBallShader,
    required this.provider,
  });

  final FragmentShader theBallShader;
  final PositionProvider provider;
}

// SamplerCamera – a thin wrapper around CameraComponent.
class SamplerCamera extends CameraComponent {
  SamplerCamera._internal({
    required this.samplerOwner,
    required this.hudComponents,
    required this.pixelRatio,
  }) : super.withFixedResolution(
          width: 0,
          height: 0,
          world: World(),
        );

  final SamplerOwner samplerOwner;
  final List<CameraComponent> hudComponents;
  final double pixelRatio;

  static SamplerCamera withFixedResolution({
    required World world,
    required SamplerOwner samplerOwner,
    required List<CameraComponent> hudComponents,
    required double width,
    required double height,
    required double pixelRatio,
  }) {
    final cam = SamplerCamera._internal(
      samplerOwner: samplerOwner,
      hudComponents: hudComponents,
      pixelRatio: pixelRatio,
    );
    cam.world = world;
    cam.viewfinder = Viewfinder();
    return cam;
  }
}

// Simple InputHandler placeholder.
class InputHandler extends Component {}

// Empty mixin to satisfy the original declaration.
mixin SingleGameInstance {}

// -----------------------------------------------------------------------------
// Concrete implementation of the abstract CrystalWorld used throughout the
// game. It extends Flame's [World].
// -----------------------------------------------------------------------------
class _ConcreteCrystalWorld extends World implements PositionProvider {
  Vector2 _position = Vector2.zero();
  double _innerAngle = 0.0;

  Vector2 get position => _position;

  set position(Vector2 value) => _position = value;

  double get angle => _innerAngle;

  set angle(double value) => _innerAngle = value;

  // Internal mutators (not part of the public API).
  void setPosition(Vector2 value) => _position = value;
  void setAngle(double value) => _innerAngle = value;
}

// -----------------------------------------------------------------------------
// Main game class.
// -----------------------------------------------------------------------------
class CrystalBallGame extends FlameGame
    with
        HasKeyboardHandlerComponents,
        HasCollisionDetection,
        SingleGameInstance {
  CrystalBallGame({
    required this.textStyle,
    required this.random,
    required this.gameCubit,
    required this.scoreCubit,
    required this.highScoreCubit,
    required this.assetsCache,
    required this.pixelRatio,
  }) : super() {
    images.prefix = '';
    camera.removeFromParent();
    add(cameraWithCameras);

    add(dummyWorld);
    world.add(inputHandler);
  }

  // A concrete, non‑nullable world instance used throughout the class.
  static final PositionProvider _gameWorld = _ConcreteCrystalWorld();

  final Random random;
  final TextStyle textStyle;
  final double pixelRatio;

  final GameCubit gameCubit;
  final ScoreCubit scoreCubit;
  final HighScoreCubit highScoreCubit;

  final AssetsCache assetsCache;

  // Initialise the input handler lazily.
  late final InputHandler inputHandler = InputHandler();

  FutureOr<void> addCamera(CameraComponent component) {
    return add(component..follow(_gameWorld as ReadOnlyPositionProvider));
  }

  final dummyWorld = flame.World();

  late final cameraWithCameras = SamplerCamera.withFixedResolution(
    world: _gameWorld as World,
    samplerOwner: GroundSamplerOwner(
      groundShader: assetsCache.groundShader,
      rocksShader: assetsCache.rocksShader,
      fogShader: assetsCache.fogShader,
      classicCamera: classicCamera,
      provider: _gameWorld,
    ),
    hudComponents: [
      classicCamera..follow(_gameWorld as ReadOnlyPositionProvider),
      fogCamera..follow(_gameWorld as ReadOnlyPositionProvider),
      platformGlowCamera..follow(_gameWorld as ReadOnlyPositionProvider),
      theBallGlowCamera..follow(_gameWorld as ReadOnlyPositionProvider),
    ],
    width: kCameraSize.width,
    height: kCameraSize.height,
    pixelRatio: pixelRatio,
  );

  late final classicCamera = CameraComponent.withFixedResolution(
    width: kCameraSize.width,
    height: kCameraSize.height,
    world: _gameWorld as World,
  );

  late final fogCamera = SamplerCamera.withFixedResolution(
    world: _gameWorld as World,
    samplerOwner: FogSamplerOwner(
      fogShader: assetsCache.fogShader,
      provider: _gameWorld,
    ),
    width: kCameraSize.width,
    height: kCameraSize.height,
    pixelRatio: pixelRatio,
    hudComponents: const [],
  );

  late final platformGlowCamera = SamplerCamera.withFixedResolution(
    world: _gameWorld as World,
    samplerOwner: PlatformsSamplerOwner(
      platformsShader: assetsCache.platformsShader,
      provider: _gameWorld,
    ),
    width: kCameraSize.width,
    height: kCameraSize.height,
    pixelRatio: pixelRatio,
    hudComponents: const [],
  );

  late final theBallGlowCamera = SamplerCamera.withFixedResolution(
    world: _gameWorld as World,
    samplerOwner: TheBallSamplerOwner(
      theBallShader: assetsCache.theBallShader,
      provider: _gameWorld,
    ),
    width: kCameraSize.width,
    height: kCameraSize.height,
    pixelRatio: pixelRatio,
    hudComponents: const [],
  );

  int counter = 0;

  // Background color for the game.
  Color backgroundColor() => const Color(0x00000000);

  @override
  Future<void> onLoad() async {}
}

// -----------------------------------------------------------------------------
// Assets cache.
// -----------------------------------------------------------------------------
class AssetsCache {
  AssetsCache({
    // images
    required this.rocksRightImage,
    required this.rocksLeftImage,
    required this.rockBottom1Image,
    required this.bgRockBaseImage,
    required this.bgRockPillarImage,
    required this.logoImage,
    // shaders
    required this.platformsShader,
    required this.theBallShader,
    required this.groundShader,
    required this.rocksShader,
    required this.fogShader,
  });

  static Future<AssetsCache> loadAll() async {
    final [
      rocksRight,
      rocksLeft,
      rocksBottom1,
      bgrockbase,
      bgrockpillar,
      logo,
    ] = await Future.wait([
      _loadImage(Assets.images.rocksr.keyName),
      _loadImage(Assets.images.rocksl2.keyName),
      _loadImage(Assets.images.bottomRocks1.keyName),
      _loadImage(Assets.images.bgrockbase.keyName),
      _loadImage(Assets.images.bgrockpillar.keyName),
      _loadImage(Assets.images.turilogo.keyName),
    ]);

    final [
      platformsShader,
      theBallShader,
      groundShader,
      rocksShader,
      fogShader,
    ] = await Future.wait([
      _loadShader('shaders/platforms.glsl'),
      _loadShader('shaders/the_ball.glsl'),
      _loadShader('shaders/ground.glsl'),
      _loadShader('shaders/rocks.glsl'),
      _loadShader('shaders/fog.glsl'),
    ]);

    return AssetsCache(
      // images
      rocksRightImage: rocksRight,
      rocksLeftImage: rocksLeft,
      rockBottom1Image: rocksBottom1,
      bgRockBaseImage: bgrockbase,
      bgRockPillarImage: bgrockpillar,
      logoImage: logo,
      // shaders
      platformsShader: platformsShader,
      theBallShader: theBallShader,
      groundShader: groundShader,
      rocksShader: rocksShader,
      fogShader: fogShader,
    );
  }

  static Future<Image> _loadImage(String name) async {
    final data = await Flame.bundle.load(name);
    final bytes = Uint8List.view(data.buffer);
    return await decodeImageFromList(bytes);
  }

  static Future<FragmentShader> _loadShader(String name) async {
    try {
      final program = await FragmentProgram.fromAsset(name);
      return program.fragmentShader();
    } catch (error, stackTrace) {
      FlutterError.reportError(
        FlutterErrorDetails(exception: error, stack: stackTrace),
      );
      rethrow;
    }
  }

  final Image rocksRightImage;
  final Image rocksLeftImage;
  final Image rockBottom1Image;
  final Image bgRockBaseImage;
  final Image bgRockPillarImage;
  final Image logoImage;

  final FragmentShader platformsShader;
  final FragmentShader theBallShader;
  final FragmentShader groundShader;
  final FragmentShader rocksShader;
  final FragmentShader fogShader;
}

// -----------------------------------------------------------------------------
// Placeholder constants and extensions.
// -----------------------------------------------------------------------------
const kCameraSize = (800.0, 600.0);

extension _CameraSizeExtension on (double, double) {
  double get width => $1;
  double get height => $2;
}

// -----------------------------------------------------------------------------
// Placeholder cubit definitions.
// -----------------------------------------------------------------------------
class GameCubit extends Cubit<dynamic> {
  GameCubit() : super(null);
}

class ScoreCubit extends Cubit<dynamic> {
  ScoreCubit() : super(null);
}

class HighScoreCubit extends Cubit<dynamic> {
  HighScoreCubit() : super(null);
}

// -----------------------------------------------------------------------------
// Minimal assets placeholder.
// -----------------------------------------------------------------------------
class _ImageAsset {
  final String keyName;
  const _ImageAsset(this.keyName);
}

class _Images {
  const _Images();

  final _ImageAsset rocksr = _ImageAsset('rocksr.png');
  final _ImageAsset rocksl2 = _ImageAsset('rocksl2.png');
  final _ImageAsset bottomRocks1 = _ImageAsset('bottomRocks1.png');
  final _ImageAsset bgrockbase = _ImageAsset('bgrockbase.png');
  final _ImageAsset bgrockpillar = _ImageAsset('bgrockpillar.png');
  final _ImageAsset turilogo = _ImageAsset('turilogo.png');
}

class Assets {
  static const images = _Images();
}