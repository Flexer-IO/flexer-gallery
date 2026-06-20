import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/model.dart';
import 'deps/spritewidget/spritewidget.dart';

import '../environment/scene.dart';
import '../utils/assets_loader.dart';

class NosliwmichaelFlutterClockPage extends StatefulWidget {
  const NosliwmichaelFlutterClockPage({super.key});

  @override
  State<NosliwmichaelFlutterClockPage> createState() =>
      _NosliwmichaelFlutterClockPageState();
}

class _NosliwmichaelFlutterClockPageState
    extends State<NosliwmichaelFlutterClockPage> {
  ClockModel? _model;
  ImageMap? _images;
  SpriteSheet? _spriteSheet;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    final images = await loadWeatherImages();
    final spriteSheet = await loadSpriteSheet();
    final model = ClockModel();

    if (mounted) {
      setState(() {
        _images = images;
        _spriteSheet = spriteSheet;
        _model = model;
        _loading = false;
      });
    }
  }

  @override
  void dispose() {
    _model?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    return Scene(_model!, _images!, _spriteSheet!);
  }
}
