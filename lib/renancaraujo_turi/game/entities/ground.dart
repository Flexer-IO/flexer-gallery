import 'dart:ui';

import '../game.dart';
import '../constants.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';

/// Extension to allow treating a [Vector2] like a [Size] for legacy code.
extension Vector2Size on Vector2 {
  double get width => x;
  double get height => y;
}

class Ground extends Component {
  Ground() : super(children: [Rectangle(kPlayerSize.height / 2)]) {
    rectangle = children.first as Rectangle;
  }

  late final Rectangle rectangle;

  @override
  void renderTree(Canvas canvas) {
    if (canvas is SamplerCanvas) {
      if (canvas.owner is PlatformsSamplerOwner) {
        return;
      }
    }
    super.renderTree(canvas);
  }
}

class Rectangle extends PositionComponent
    with
        CollisionCallbacks,
        ParentIsA<Ground>,
        HasGameRef<FlameGame> {
  Rectangle(this.ogY)
      : super(
          anchor: Anchor.topCenter,
          position: Vector2(0, ogY),
          size: Vector2(
            kCameraSize.width,
            kCameraSize.height / 2,
          ),
          children: [
            RectangleHitbox(
              size: Vector2(
                kCameraSize.width,
                kCameraSize.height / 2,
              ),
            ),
            RectangleHitbox(
              position: Vector2(0, kPlayerRadius),
              size: Vector2(
                kCameraSize.width,
                kCameraSize.height / 2,
              ),
            ),
            RectangleHitbox(
              position: Vector2(0, kPlayerRadius * 2),
              size: Vector2(
                kCameraSize.width,
                kCameraSize.height / 2,
              ),
            ),
          ],
        );

  final double ogY;

  double get top => absolutePositionOfAnchor(Anchor.topCenter).y;
}