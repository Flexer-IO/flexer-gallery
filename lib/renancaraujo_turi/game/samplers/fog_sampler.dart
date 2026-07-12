import 'dart:ui' hide Shader;

import '../game.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flutter_shaders/flutter_shaders.dart';
import 'package:collection/collection.dart';

/// Minimal implementation of the Flame Shaders `SamplerOwner` API to avoid
/// external package dependencies.
abstract class SamplerOwner {
  final FragmentShader shader;
  SamplerOwner(this.shader);
  Sampler get sampler;
  int get passes;
}

/// Wrapper class used by Flame Shaders to represent a sampler callback.
class Sampler {
  final void Function(List<Image> images, Size size, Canvas canvas) _callback;
  Sampler(this._callback);
  void call(List<Image> images, Size size, Canvas canvas) => _callback(images, size, canvas);
}

class FogSamplerOwner extends SamplerOwner {
  final CrystalWorld world;

  FogSamplerOwner(FragmentShader shader, this.world) : super(shader);

  @override
  Sampler get sampler => Sampler(_sampler);

  void _sampler(List<Image> images, Size size, Canvas canvas) {
    if (canvas is SamplerCanvas) {
      if (canvas.pass == 1) {
        return;
      }
    }
    applyFog(size, canvas);
  }

  @override
  int get passes => 0;

  double time = 0.0;

  void update(double dt) {
    // `SamplerOwner` does not define `update`, so we simply handle the time increment here.
    time += dt;
  }

  void applyFog(Size size, Canvas canvas) {
    // Obtain the origin from the world's camera component, falling back to (0,0) if unavailable.
    final Vector2 origin = (world.camera?.visibleWorldRect.topLeft ?? Offset.zero).toVector2();

    // Resolve the camera size to a Vector2 regardless of whether `kCameraSize` is a `Size` or a `Vector2`.
    final Vector2 cameraSizeVector = () {
      // ignore: avoid_dynamic_calls
      final dynamic cs = kCameraSize;
      if (cs is Size) {
        return cs.toVector2();
      } else if (cs is Vector2) {
        return cs;
      } else {
        // Fallback: treat it as a scalar and create a square Vector2.
        final double scalar = cs as double;
        return Vector2(scalar, scalar);
      }
    }();

    shader.setFloatUniforms((value) {
      value.setSize(size);

      final Vector2 groundPos =
          (world as dynamic).ground.rectangle.absolutePosition + Vector2(0, 200);
      final Vector2 uvGround = (groundPos - origin)..divide(cameraSizeVector);

      final Vector2 cameraVerticalPos =
          (world as dynamic).cameraTarget.position.clone()..absolute();
      final Vector2 uvCameraVerticalPos = cameraVerticalPos..divide(cameraSizeVector);

      value
        ..setFloat(uvGround.y)
        ..setFloat(uvCameraVerticalPos.y)
        ..setFloat(0.3)
        ..setFloat(time);
    });

    canvas
      ..save()
      ..drawRect(
        Offset.zero & size,
        Paint()
          ..shader = shader
          ..blendMode = BlendMode.darken,
      )
      ..restore();
  }
}

// Extension to provide a nullable camera getter for CrystalWorld.
extension CrystalWorldCameraExtension on CrystalWorld {
  CameraComponent? get camera {
    // Return the first CameraComponent found among the world's children, if any.
    // This mirrors typical Flame world setups where a CameraComponent is added as a child.
    return children.whereType<CameraComponent>().firstOrNull;
  }
}