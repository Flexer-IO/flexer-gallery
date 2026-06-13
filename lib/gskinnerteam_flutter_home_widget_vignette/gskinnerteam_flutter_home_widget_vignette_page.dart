import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'home_widget_controller.dart';
import 'home_widget_bg_image.dart';

class GskinnerteamFlutterHomeWidgetVignettePage extends StatefulWidget {
  const GskinnerteamFlutterHomeWidgetVignettePage({super.key});

  @override
  State<GskinnerteamFlutterHomeWidgetVignettePage> createState() => _GskinnerteamFlutterHomeWidgetVignettePageState();
}

class _GskinnerteamFlutterHomeWidgetVignettePageState extends State<GskinnerteamFlutterHomeWidgetVignettePage> {
  final _counter = ValueNotifier<int>(3);
  final _homeWidgetController = CounterHomeWidgetController();

  @override
  void initState() {
    super.initState();
    _homeWidgetController.init();
    _counter.addListener(() {
      _homeWidgetController.setCountAndRender(count: _counter.value);
    });
  }

  @override
  void dispose() {
    _counter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ValueListenableBuilder(
              valueListenable: _counter,
              builder: (context, value, child) {
                return HomeWidgetBgImage(count: _counter.value, size: const Size(200, 200), color: Colors.white);
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _counter.value++;
              },
              child: const Text('Increment'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                _counter.value--;
              },
              child: const Text('Decrement'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                _homeWidgetController.setColor(const Color(0xFF00FF00));
              },
              child: const Text('Change Color'),
            ),
          ],
        ),
      ),
    );
  }
}