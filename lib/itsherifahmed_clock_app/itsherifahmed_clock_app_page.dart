import 'package:flutter/material.dart';
import 'deps/get/get.dart';
import '../controller/controller.dart';
import '../view/HomePage.dart';

class ItsherifahmedClockAppPage extends StatefulWidget {
  const ItsherifahmedClockAppPage({super.key});

  @override
  State<ItsherifahmedClockAppPage> createState() => _ItsherifahmedClockAppPageState();
}

class _ItsherifahmedClockAppPageState extends State<ItsherifahmedClockAppPage> {
  @override
  void initState() {
    super.initState();
    // Register the library's controller if it hasn't been registered yet.
    if (!Get.isRegistered<Controller>()) {
      Get.put(Controller());
    }
  }

  @override
  Widget build(BuildContext context) {
    // Return the library's main entry widget.
    return const HomePage();
  }
}
