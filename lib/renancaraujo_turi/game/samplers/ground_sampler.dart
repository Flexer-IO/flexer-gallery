import 'dart:ui';

import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flutter_shaders/flutter_shaders.dart' as flutter_shaders;

// Define a default camera size record for use in calculations.
// Adjust the values as needed to match the original project's constants.
const kCameraSize = (800.0, 600.0);

typedef Sampler = void Function(List<Image> images, Size size, Canvas canvas);

abstract class SamplerOwner {
  SamplerOwner(this.shader);
  final FragmentShader shader;
  Sampler get sampler;
}

// ---------------------------------------------------------------------------

class GroundSamplerOwner extends SamplerOwner {
  GroundSamplerOwner(
    FragmentShader shader,
    this.rocksShader,
    this.fogShader,
    this.innerCamera, {
    required this.world,
  }) : super(shader) {
    // Store the provided shader locally.
    _shader = shader;
  }

  final CameraComponent innerCamera;

  CameraComponent get cameraComponent => innerCamera;

  final dynamic world;

  final FragmentShader rocksShader;
  final FragmentShader fogShader;

  // Local storage for the main shader.
  late final FragmentShader _shader;

  // Expose the shader for internal use.
  FragmentShader get shader => _shader;

  int get passes => 2;

  double time = 0;

  // The superclass does not define an `update` method, so we simply implement it here.
  void update(double dt) {
    time += dt;
  }

  Vector2 worldToUv(Vector2 coord) {
    final cameraViewport = cameraComponent.viewport;
    return innerCamera.localToGlobal(coord)..divide(cameraViewport.size);
  }

  // Renamed to avoid conflict with the inherited `sampler` field.
  void _sample(List<Image> images, Size size, Canvas canvas) {
    final groundpos = world.ground!.rectangle.absolutePosition + Vector2(0, 100);
    final uvGround = worldToUv(groundpos).y;

    final ssize = (innerCamera.viewport.size - Vector2.all(2))..ceil();
    final spos = (innerCamera.viewport.position + Vector2.all(2))..ceil();

    canvas.clipRect(spos.toOffset() & ssize.toSize(), doAntiAlias: false);

    shader
      ..setFloatUniforms((value) {
        value
          ..setSize(size)
          ..setFloat(uvGround)
          ..setFloat(time);
      })
      ..setImageSampler(0, images[0]);

    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..shader = shader
        ..blendMode = BlendMode.srcOver,
    );

    // fog
    applyFog(size, canvas);

    // rocks
    rocksShader
      ..setFloatUniforms((value) {
        value.setSize(size);
      })
      ..setImageSampler(0, images[1])
      ..setImageSampler(1, images[0]);

    canvas.drawRect(
      Offset.zero & size,
      Paint()..shader = rocksShader,
    );
  }

  // Expose the sampler function.
  @override
  Sampler get sampler => _sample;

  void applyFog(Size size, Canvas canvas) {
    fogShader.setFloatUniforms((value) {
      value.setSize(size);

      final groundpos =
          world.ground!.rectangle.absolutePosition + Vector2(0, 1800);
      final uvGround = worldToUv(groundpos).y;

      final cameraVerticalPos = world.cameraTarget!.position.clone()
        ..absolute()
        ..y *= 1.9;

      final uvCameraVerticalPos = cameraVerticalPos
        ..divide(Vector2(kCameraSize.$1, kCameraSize.$2));

      value
        ..setFloat(uvGround)
        ..setFloat(uvCameraVerticalPos.y)
        ..setFloat(3.4)
        ..setFloat(time * 1.2);
    });

    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..shader = fogShader
        ..blendMode = BlendMode.plus,
    );
  }
}

extension on flutter_shaders.UniformsSetter {}