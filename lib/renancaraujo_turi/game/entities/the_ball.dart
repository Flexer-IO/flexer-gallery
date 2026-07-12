import 'dart:math';
import 'dart:ui';

import '../game.dart' hide Platform, kOpeningDuration;
import '../constants.dart';
import 'ground.dart';
import 'platform.dart';
import 'reaper.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/animation.dart';
import 'package:flame/game.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ---------------------------------------------------------------------------
// Definition of GameState enum (fallback if not imported).
// ---------------------------------------------------------------------------
enum GameState { initial, starting, playing, gameOver }

// ---------------------------------------------------------------------------
// Implementation of a concrete EffectController used by the original code.
// This satisfies all abstract members of EffectController and provides mutable
// duration and curve setters required by the widget logic.
// ---------------------------------------------------------------------------

class GoodCurvedEffectController implements EffectController {
  GoodCurvedEffectController(this._duration, this._curve);

  double _duration;
  Curve _curve;

  // Mutable setters used in the original code.
  set duration(double value) => _duration = value;
  set curve(Curve value) => _curve = value;

  // -------------------------------------------------------------------------
  // Required getters.
  // -------------------------------------------------------------------------
  double get duration => _duration;

  Curve get curve => _curve;

  double get reverseDuration => 0.0;

  double get reverseSpeed => 0.0;

  Curve? get reverseCurve => Curves.linear;

  bool get infinite => false;

  bool get alternate => false;

  int? get repeatCount => null;

  double get startDelay => 0.0;

  double get atMaxDuration => 0.0;

  double get atMinDuration => 0.0;

  void Function()? get onMax => null;

  void Function()? get onMin => null;

  // -------------------------------------------------------------------------
  // EffectController state tracking.
  // -------------------------------------------------------------------------
  bool _completed = false;
  double _elapsed = 0.0;

  bool get completed => _completed;

  double get progress =>
      _duration == 0 ? 1.0 : (_elapsed / _duration).clamp(0.0, 1.0);

  bool get isInfinite => false;

  bool get isRandom => false;

  bool get started => _elapsed > 0;

  @override
  void onMount(Effect effect) {}

  // -------------------------------------------------------------------------
  // EffectController abstract methods.
  // -------------------------------------------------------------------------
  @override
  double advance(double dt) {
    _elapsed += dt;
    if (_elapsed >= _duration) {
      _elapsed = _duration;
      _completed = true;
    }
    return progress;
  }

  @override
  double recede(double dt) {
    _elapsed -= dt;
    if (_elapsed <= 0) {
      _elapsed = 0;
      _completed = false;
    }
    return progress;
  }

  @override
  void setToStart() {
    _elapsed = 0;
    _completed = false;
  }

  @override
  void setToEnd() {
    _elapsed = _duration;
    _completed = true;
  }
}

// ---------------------------------------------------------------------------
// Marker interface for a canvas that can be sampled.
// ---------------------------------------------------------------------------

abstract class SamplerCanvas implements Canvas {
  dynamic get owner;
}

// Marker class for the owner of a platforms sampler.
class PlatformsSamplerOwner {}

class TheBall extends PositionComponent
    with
        FlameBlocListenable<BlocBase<GameState>, GameState>,
        CollisionCallbacks,
        HasGameRef<FlameGame> {
  TheBall({
    required Vector2 super.position,
  }) : super(
          anchor: Anchor.center,
          priority: 100000,
          children: [
            CircleHitbox(
              radius: kPlayerRadius,
              anchor: Anchor.center,
            ),
          ],
        );

  final Vector2 velocity = Vector2.zero();

  final double _gravity = kGravity;

  double gama = 0.1;
  double get radius => (1.0 - gama) / 3;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await add(glowEffect);
  }

  final GoodCurvedEffectController effectController = GoodCurvedEffectController(
    0.4,
    Curves.easeInOut,
  )..setToEnd();

  late final _PlatformGamaEffect glowEffect =
      _PlatformGamaEffect(0.1, effectController);

  void jump() {
    velocity.y = -kJumpVelocity;
  }

  @override
  void onNewState(GameState state) {
    super.onNewState(state);
    switch (state) {
      case GameState.initial:
        position = Vector2.zero();
        _glowTo(to: 0.1);
      case GameState.starting:
        position = Vector2.zero();
        _glowTo(to: 0.6, duration: kOpeningDuration);
        jump();
      case GameState.playing:
        break;
      case GameState.gameOver:
        position = Vector2.zero();
        _glowTo(to: 0.1, duration: 1);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!(((bloc as dynamic)?.isPlaying) ?? false)) {
      velocity
        ..y = 0
        ..x = 0;
      return;
    }

    velocity.y += _gravity;
    final horzV = pow(velocity.y.abs(), 1.8) * 0.0015;
    velocity.x = (((game as dynamic)?.inputHandler?.directionalCoefficient) ?? 0) *
        horzV;

    final maxH = kCameraSize.width / 2 - kPlayerRadius - 50;

    position += velocity * dt;
    position.x = clampDouble(x, -maxH, maxH);
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (!(((bloc as dynamic)?.isPlaying) ?? false)) return;
    if (other is Ground || other is ParentIsA<Ground>) {
      velocity.y = 0;
      position.y = 0;
      jump();
      ((game.world as dynamic)?.cameraTarget?.go(
        to: Vector2(0, -400),
        duration: 4,
        curve: Curves.decelerate,
      ));
    }
    if (other is Platform && velocity.y > 0) {
      velocity.y = 0;
      position.y = other.topLeftPosition.y - kPlayerRadius;
      jump();
      ((game.world as dynamic)?.cameraTarget?.go(
        to: Vector2(0,
            other.topLeftPosition.y - kCameraSize.height / 2 + 300),
        duration: 10,
        curve: Curves.easeOutBack,
      ));
      ((other as dynamic)?.glowTo(to: 1.45, duration: 0.5));
    }

    if (other is Reaper && velocity.y > 0) {
      ((bloc as dynamic)?.gameOver());
      velocity.y = 0;
    }
  }

  @override
  void renderTree(Canvas canvas) {
    if (canvas is SamplerCanvas && canvas.owner is PlatformsSamplerOwner) {
      return;
    }
    super.renderTree(canvas);
  }

  void _glowTo({
    required double to,
    Curve curve = Curves.easeInOut,
    double duration = 0.1,
  }) {
    effectController
      ..duration = duration
      ..curve = curve;

    glowEffect._change(to: to);
  }
}

class _PlatformGamaEffect extends Effect with EffectTarget<TheBall> {
  _PlatformGamaEffect(this._to, super.controller);

  @override
  void onMount() {
    super.onMount();
    _from = target.gama;
  }

  double _to;
  late double _from;

  @override
  bool get removeOnFinish => false;

  @override
  void apply(double progress) {
    final delta = _to - _from;
    final position = _from + delta * progress;
    target.gama = position;
  }

  void _change({required double to}) {
    reset();

    _to = to;
    _from = target.gama;
  }
}