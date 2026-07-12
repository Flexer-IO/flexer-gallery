import 'dart:math';

import 'game.dart' hide Platform;
import 'package:flame/components.dart' hide World;
import 'package:flame/camera.dart' as flame_camera;
import 'package:flame/extensions.dart';
import 'package:flame_bloc/flame_bloc.dart';

// Local component imports (relative)
import 'components/platform_spawner.dart' hide Platform;
import 'components/game_state_sync.dart' hide Platform;
import 'components/side_rocks_spawner.dart' as side_rocks_spawner;
import 'components/bg_rock_pillar_spawner.dart' as bg_rock_pillar_spawner;
import 'components/logo_component.dart' as logo_component;
import 'components/reaper.dart' as reaper;
import 'components/the_ball.dart' as the_ball;
import 'components/ground.dart' as ground;
import 'components/bottom_rock1.dart' as bottom_rock1;
import 'components/bottom_rock2.dart' as bottom_rock2;
import 'components/bg_rock_base.dart' as bg_rock_base;
import 'components/bg_rock_base2.dart' as bg_rock_base2;
import 'components/platform.dart' show Platform;
import 'components/camera_target.dart' as camera_target;

class CrystalWorld extends flame_camera.World {
  CrystalWorld({
    // ignore: strict_raw_type
    required List<FlameBlocProvider> providers,
    required this.random,
    super.priority = -0x7fffffff,
  }) {
    flameMultiBlocProvider = FlameMultiBlocProvider(
      providers: providers,
      children: [
        PlatformSpawner(random: random),
        GameStateSync(),
        side_rocks_spawner.SideRocksSpawner(),
        bg_rock_pillar_spawner.BgRockPillarSpawner(),
        logo_component.LogoComponent(),
        reaper.Reaper(),
        the_ball.TheBall(position: Vector2.zero()),
        ground.Ground(),
      ],
    );

    add(flameMultiBlocProvider);
    add(camera_target.CameraTarget());
  }

  late final FlameMultiBlocProvider flameMultiBlocProvider;

  final Random random;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(bottom_rock1.BottomRock1());
    add(bottom_rock2.BottomRock2());
    add(bg_rock_base.BGRockBase());
    add(bg_rock_base2.BGRockBase2());
    children.register<Platform>();
  }

  List<Platform> getPlatforms() {
    return children.query<Platform>();
  }
}