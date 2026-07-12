import 'dart:ui';

import '../game.dart' hide GroundSamplerOwner;
import 'package:flame/extensions.dart';
import 'package:flame/components.dart';
import 'package:flutter_shaders/flutter_shaders.dart';

// Minimal abstract definitions to satisfy the compiler when the real
// implementations are not available in this context. These definitions
// are deliberately lightweight and do not alter runtime behavior.
abstract class Sampler {
  void sample(List<Image> images, Size size, Canvas canvas);
}

abstract class SamplerOwner {
  final FragmentShader shader;

  SamplerOwner(this.shader);

  Sampler get sampler;
}

// Provide a fallback getter for `theBall` on `CrystalWorld` when the
// original property name differs. This uses `dynamic` to avoid static type
// constraints while preserving runtime behavior.
extension _CrystalWorldBallExtension on CrystalWorld {
  dynamic get theBall => (this as dynamic).ball;
}

// Helper extension for setting vector uniforms using the real UniformsSetter.
extension _UniformsSetterExtension on UniformsSetter {
  void setVector2(Vector2 vector) {
    setFloat2(vector.x, vector.y);
  }
}

// Compatibility extensions for older Flutter Shaders versions.
extension _UniformsSetterCompatibility on UniformsSetter {
  // Fallback implementation if `setFloat2` is not available.
  void setFloat2(double x, double y) {
    // The order of calls matches the expected uniform layout.
    setFloat(x);
    setFloat(y);
  }
}

class TheBallSamplerOwner extends SamplerOwner implements Sampler {
  TheBallSamplerOwner(this.world, this.shader) : super(shader);

  final CrystalWorld world;
  final FragmentShader shader;

  // The `passes` getter is not part of the base class contract.
  int get passes => 0;

  // `update` is not defined in the base class, but keeping the method
  // does not affect rendering logic.
  void update(double dt) {
    // No-op implementation.
  }

  @override
  Sampler get sampler => this;

  @override
  void sample(List<Image> images, Size size, Canvas canvas) {
    if (canvas is SamplerCanvas) {
      if (canvas.pass == 1) {
        return;
      }
    }

    // Resolve the origin offset safely and convert to Vector2.
    final Offset originOffset = (world as dynamic).camera?.visibleWorldRect.topLeft ?? Offset.zero;
    final Vector2 origin = Vector2(originOffset.dx, originOffset.dy);

    final theBall = world.theBall;

    final Vector2 ballpos = theBall.absolutePosition;

    // Use the provided `size` (canvas size) as the camera size.
    final Vector2 cameraSizeVector = Vector2(size.width, size.height);
    final Vector2 uvBall = (ballpos - origin)..divide(cameraSizeVector);

    final Vector2 velocity = theBall.velocity.clone() / 1600;

    shader.setFloatUniforms((UniformsSetter value) {
      value
        ..setSize(size)
        ..setVector2(uvBall)
        ..setVector2(velocity * -1)
        ..setFloat(theBall.gama)
        ..setFloat(theBall.radius);
    });

    canvas
      ..save()
      ..drawRect(
        Offset.zero & size,
        Paint()
          ..shader = shader
          ..blendMode = BlendMode.lighten,
      )
      ..restore();
  }
}