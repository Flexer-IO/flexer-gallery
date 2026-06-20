import 'dart:ui';

import '../anchor.dart';
import '../extensions/vector2.dart';
import './particle.dart';
import '../sprite.dart';

export '../sprite.dart';

/// A [Particle] which applies certain [Sprite].
class SpriteParticle extends Particle {
  final Sprite sprite;
  final Vector2? position;
  final Vector2? size;
  final Anchor anchor;
  final Paint? overridePaint;

  SpriteParticle({
    required this.sprite,
    this.position,
    this.size,
    this.anchor = Anchor.center,
    this.overridePaint,
    super.lifespan,
  });

  @override
  void render(Canvas canvas) {
    sprite.render(
      canvas,
      position: position,
      size: size,
      anchor: anchor,
      overridePaint: overridePaint,
    );
  }
}
