import 'dart:typed_data';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart' show Colors, Color;
import 'package:flutter_shaders/flutter_shaders.dart';

// -----------------------------------------------------------------------------
// Placeholder definitions for missing project files.
// These stubs provide the minimal API required for this file to compile
// while preserving the original rendering behavior.
// -----------------------------------------------------------------------------

/// Minimal abstract base class for sampler owners.
abstract class SamplerOwner {
  final FragmentShader shader;
  SamplerOwner(this.shader);

  int get passes;
  void update(double dt);
  void sampler(List<Image> images, Size size, Canvas canvas);
}

/// Placeholder for the game world that provides platforms.
class CrystalWorld {
  /// Returns the list of platforms in the world.
  List<Platform> getPlatforms() => const [];

  // Optional camera component for convenience; may be null.
  CameraComponent? get cameraComponent => null;
  // Optional legacy camera field.
  CameraComponent? get camera => null;
}

/// Placeholder constant representing the camera size.
const Size kCameraSize = Size(800, 600);

/// Minimal platform interface used by the sampler.
abstract class Platform {
  /// Returns the absolute position of the given [anchor] in world coordinates.
  Vector2 absolutePositionOfAnchor(Anchor anchor);
}

/// Extension providing the missing members on [Platform] that exist in the
/// original code base.
extension PlatformExtensions on Platform {
  List<Color> get gradient => (this as dynamic).gradient as List<Color>;
  double get glowGama => (this as dynamic).glowGama as double;
}

// -----------------------------------------------------------------------------
// Actual implementation.
// -----------------------------------------------------------------------------

class PlatformsSamplerOwner extends SamplerOwner {
  PlatformsSamplerOwner(super.shader, this.world);

  final CrystalWorld world;

  late List<Platform> _platforms;

  CameraComponent? get cameraComponent =>
      (world as dynamic).cameraComponent ??
      (world as dynamic).camera as CameraComponent?;

  @override
  int get passes => 0;

  @override
  void update(double dt) {
    // Update the cached platforms list from the world.
    _platforms = world.getPlatforms();
  }

  @override
  void sampler(List<Image> images, Size size, Canvas canvas) {
    shader.setFloatUniforms((UniformsSetter value) {
      value
        ..setSize(size)
        ..setPlatforms(_platforms, cameraComponent!);
    });

    canvas
      ..save()
      ..drawRect(
        Offset.zero & size,
        Paint()
          ..shader = shader
          ..blendMode = BlendMode.multiply,
      )
      ..restore();
  }
}

// -----------------------------------------------------------------------------
// UniformsSetter extensions used by the shader.
// -----------------------------------------------------------------------------

extension on UniformsSetter {
  void setVector64(Vector2 vector) {
    final storage = Float32List.fromList(vector.storage);
    setFloats(storage);
  }

  void setRGB(Color color) {
    setFloat(color.red / 255);
    setFloat(color.green / 255);
    setFloat(color.blue / 255);
  }

  void setPlatforms(List<Platform> platforms, CameraComponent cameraComponent) {
    // Convert the camera's visible world top‑left from Offset to Vector2.
    final origin = cameraComponent.visibleWorldRect.topLeft.toVector2();

    // positions
    for (var i = 0; i < 18; i++) {
      if (i >= platforms.length) {
        setVector64(Vector2.zero());
        setVector64(Vector2.zero());
        continue;
      }

      final platform = platforms[i];
      final abscl = platform.absolutePositionOfAnchor(Anchor.centerLeft);
      final uvcl = (abscl - origin)..divide(kCameraSize.toVector2());
      setVector64(uvcl);

      final abscr = platform.absolutePositionOfAnchor(Anchor.centerRight);
      final uvcr = (abscr - origin)..divide(kCameraSize.toVector2());
      setVector64(uvcr);
    }

    // colorsL
    for (var i = 0; i < 18; i++) {
      if (i >= platforms.length) {
        setRGB(Colors.transparent);
        continue;
      }
      final platform = platforms[i];
      final colorL = platform.gradient[0];
      setRGB(colorL);
    }

    // colorsR
    for (var i = 0; i < 18; i++) {
      if (i >= platforms.length) {
        setRGB(Colors.transparent);
        continue;
      }
      final platform = platforms[i];
      final colorR = platform.gradient[1];
      setRGB(colorR);
    }

    // glow gama
    for (var i = 0; i < 18; i++) {
      if (i >= platforms.length) {
        setFloat(0);
        continue;
      }
      final platform = platforms[i];
      final distance = platform.glowGama;
      setFloat(distance);
    }
  }
}