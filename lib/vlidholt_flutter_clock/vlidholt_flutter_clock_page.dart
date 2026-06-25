import 'package:flutter/material.dart';
import 'clock_assets.dart';
import 'digital_firework_time_display.dart';

class VlidholtFlutterClockPage extends StatefulWidget {
  const VlidholtFlutterClockPage({super.key});

  @override
  State<VlidholtFlutterClockPage> createState() => _VlidholtFlutterClockPageState();
}

class _VlidholtFlutterClockPageState extends State<VlidholtFlutterClockPage> {
  late final Future<ClockAssets> _assetsFuture;

  @override
  void initState() {
    super.initState();
    _assetsFuture = _loadAssets();
  }

  Future<ClockAssets> _loadAssets() async {
    final assets = ClockAssets();
    await assets.load();
    return assets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<ClockAssets>(
        future: _assetsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error loading assets'));
          }
          final assets = snapshot.data!;
          return DigitalFireworkTimeDisplay(
            assets: assets,
            dateTime: DateTime.now(),
            model: null,
          );
        },
      ),
    );
  }
}
