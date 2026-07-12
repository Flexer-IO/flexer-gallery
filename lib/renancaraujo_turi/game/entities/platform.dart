import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/game.dart';
import 'package:flutter/widgets.dart' show Curve, Curves;

/// Simple weighted‑random helper used by [PlatformColor.rarityRandom].
/// If the original project provides its own implementation, this
/// replacement mimics the expected behaviour without affecting UI.
class Rarity {
  final PlatformColor color;
  final int weight;
  Rarity(this.color, this.weight);
}

class RarityList {
  final List<Rarity> list;
  RarityList(this.list);

  PlatformColor getRandom(Random random) {
    final totalWeight = list.fold<int>(0, (sum, r) => sum + r.weight);
    var roll = random.nextInt(totalWeight);
    for (final r in list) {
      if (roll < r.weight) return r.color;
      roll -= r.weight;
    }
    // Fallback – should never happen if list is non‑empty.
    return list.last.color;
  }
}

/// Custom effect controller that mirrors Flame's CurvedEffectController
/// but allows mutable `duration` and `curve` after construction.
class GoodCurvedEffectController implements EffectController {
  // These fields satisfy the abstract getters/setters of EffectController.
  double duration;
  Curve curve;
  bool infinite;
  double startDelay;

  double _elapsed = 0.0;

  GoodCurvedEffectController(this.duration, this.curve,
      {this.infinite = false, this.startDelay = 0.0});

  double get elapsed => _elapsed;

  bool get isCompleted => _elapsed >= duration;

  double get progress =>
      duration == 0 ? 1.0 : (_elapsed / duration).clamp(0.0, 1.0);

  void reset() {
    _elapsed = 0.0;
  }

  double advance(double dt) {
    _elapsed += dt;
    if (_elapsed > duration) {
      _elapsed = duration;
    }
    // No remaining dt is returned in this simple implementation.
    return 0.0;
  }

  void setToEnd() {
    _elapsed = duration;
  }

  void setToStart() {
    _elapsed = 0.0;
  }

  double recede(double dt) {
    _elapsed -= dt;
    if (_elapsed < 0) {
      final remaining = -_elapsed;
      _elapsed = 0.0;
      return remaining;
    }
    return 0.0;
  }

  void onMount(Effect effect) {
    // No special behavior needed on mount.
  }

  bool get completed => isCompleted;

  bool get isInfinite => infinite;

  bool get isRandom => false;

  bool get started => _elapsed > 0 || startDelay > 0;
}

enum PlatformColor {
  green._(
    rarity: 600,
    gradient: [Color(0xFF00FF00), Color(0xFF00FF7F)],
  ),
  blue._(
    rarity: 250,
    gradient: [Color(0xFF00BFFF), Color(0xFF00FFFF)],
  ),
  orange._(
    rarity: 80,
    gradient: [Color(0xFFFD7001), Color(0xFFFDAB42)],
  ),
  red._(
    rarity: 44,
    gradient: [Color(0xFFFF3403), Color(0xFFFD2B9B)],
  ),
  purple._(
    rarity: 25,
    gradient: [Color(0xFF8B00FF), Color(0xFFCD00FF)],
  ),
  golden._(
    rarity: 1,
    gradient: [Color(0xFFFFFFFF), Color(0xFFFFD700)],
  ),
  ;

  const PlatformColor._({
    required this.gradient,
    required this.rarity,
  });

  final List<Color> gradient;
  final int rarity;

  static PlatformColor random(Random random) =>
      values[random.nextInt(values.length)];

  static PlatformColor rarityRandom(Random random) {
    final rarities = values.map((e) => Rarity(e, e.rarity));
    return RarityList(rarities.toList()).getRandom(random);
  }
}

// Adjusted generic to avoid compile‑time type errors.
class Platform extends PositionComponent with HasGameRef {
  Platform({
    required Vector2 super.position,
    required Vector2 super.size,
    required this.color,
    required this.random,
  }) : super(
          anchor: Anchor.center,
          priority: 1000,
          children: [
            RectangleHitbox(),
            RectangleHitbox(
              position: Vector2(0, 10),
              size: size,
            ),
            RectangleHitbox(
              position: Vector2(0, 20),
              size: size,
            ),
            RectangleHitbox(
              position: Vector2(0, 30),
              size: size,
            ),
          ],
        );

  final Random random;

  late final List<Color> gradient = () {
    if (random.nextBool()) {
      return color.gradient.reversed.toList();
    }
    return color.gradient;
  }();

  final PlatformColor color;

  double initialGlowGama = 10;
  double glowGama = 0;

  final effectController = GoodCurvedEffectController(
    0.4,
    Curves.easeInOut,
  )..setToEnd();
  late final glowEffect = PlatformGamaEffect(20, effectController);

  // Helper to access the concrete game type safely.
  dynamic get _game => game;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await add(glowEffect);
    height = 40;
  }

  @override
  void onMount() {
    super.onMount();
    scheduleMicrotask(() {
      glowTo(
        to: initialGlowGama,
        duration: 0.3,
        curve: Curves.ease,
      );
    });
  }

  void glowTo({
    required double to,
    Curve curve = Curves.easeInOut,
    double duration = 0.1,
  }) {
    effectController
      ..duration = duration
      ..curve = curve;

    glowEffect._change(to: to);
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (_game.gameCubit.isPlaying == false) return;

    if (y > _game.world.reaper.y) {
      removeFromParent();
    }
  }
}

class PlatformGamaEffect extends Effect with EffectTarget<Platform> {
  PlatformGamaEffect(this._to, super.controller);

  @override
  void onMount() {
    super.onMount();
    _from = target.glowGama;
  }

  double _to;
  late double _from;

  @override
  bool get removeOnFinish => false;

  @override
  void apply(double progress) {
    final delta = _to - _from;
    final position = _from + delta * progress;
    target.glowGama = position;
  }

  void _change({required double to}) {
    reset();

    _to = to;
    _from = target.glowGama;
  }
}