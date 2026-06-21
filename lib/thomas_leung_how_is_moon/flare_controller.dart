import 'dart:math';

// Stub definitions for missing Flare classes.
// In the original project these would be provided by the Flare package.

/// Placeholder for a 2D matrix used by Flare.
class Mat2D {}

/// Represents an animation within a Flare artboard.
class ActorAnimation {
  /// Total duration of the animation in seconds.
  final double duration;

  ActorAnimation(this.duration);

  /// Applies the animation at the given [time] to the [artboard].
  /// The [mix] parameter is kept for compatibility with the original API.
  void apply(double time, FlutterActorArtboard artboard, double mix) {
    // No‑op stub implementation.
  }
}

/// Represents a Flare artboard.
class FlutterActorArtboard {
  /// Name of the artboard.
  final String name;

  FlutterActorArtboard(this.name);

  /// Retrieves an animation by its [name].
  /// Returns `null` if the animation does not exist.
  ActorAnimation? getAnimation(String name) {
    // Stub implementation returning a dummy animation.
    // In a real scenario this would look up the actual animation.
    return ActorAnimation(1.0);
  }
}

/// Base controller class for Flare animations.
abstract class FlareController {
  /// Called when the artboard is first loaded.
  void initialize(FlutterActorArtboard artboard);

  /// Called when the view transform changes.
  void setViewTransform(Mat2D viewTransform);

  /// Called each frame to advance the animation.
  /// Returns `true` if the animation should continue.
  bool advance(FlutterActorArtboard artboard, double elapsed);
}

class AnimationControls extends FlareController {
  ActorAnimation? _moonAnimation;

  double _moonPhase = 0.0;
  double _currentPhase = 0.0;
  double _smoothTime = 5.0;

  @override
  void initialize(FlutterActorArtboard artboard) {
    // Artboard and moonPhase refers to the elements defined in Rive.
    // check if it is the right artboard and get the animation you need
    if (artboard.name == "Artboard") {
      _moonAnimation = artboard.getAnimation('moonPhase');
    }
  }

  @override
  void setViewTransform(Mat2D viewTransform) {}

  @override
  bool advance(FlutterActorArtboard artboard, double elapsed) {
    if (artboard.name == "Artboard" && _moonAnimation != null) {
      _currentPhase +=
          (_moonPhase - _currentPhase) * min(1, elapsed * _smoothTime);
      _moonAnimation!
          .apply(_currentPhase * _moonAnimation!.duration, artboard, 1);
    }
    return true;
  }

  void updateMoonPhase(double amount) {
    _moonPhase = amount;
  }

  void resetMoonPhase() {
    _moonPhase = 0.0;
  }
}