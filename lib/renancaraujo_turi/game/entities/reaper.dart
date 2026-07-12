import '../game.dart';
import '../constants.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';

class Reaper extends PositionComponent with HasGameRef<FlameGame> {
  Reaper()
      : super(
          position: Vector2(0, 0),
          size: Vector2(kCameraSize.width * 2, 100),
          anchor: Anchor.topCenter,
          children: [
            RectangleHitbox(),
          ],
        );

  @override
  void update(double dt) {
    super.update(dt);
    final CrystalBallGame gameRef = game as CrystalBallGame;
    position.y = gameRef.world.cameraTarget.y +
        (kCameraSize.height + kReaperTolerance) / 2;
  }
}