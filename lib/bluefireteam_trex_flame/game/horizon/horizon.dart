import 'package:flame/components.dart';

import '../game.dart' hide HorizonLine;
import 'horizon_line.dart';

class Horizon extends PositionComponent with HasGameRef<TRexGame> {
  late final HorizonLine horizonLine = HorizonLine();

  @override
  Future<void> onLoad() async {
    await add(horizonLine);
  }

  @override
  void update(double dt) {
    y = (gameRef.size.y / 2) + 21.0;
    super.update(dt);
  }

  void reset() {
    horizonLine.reset();
  }
}