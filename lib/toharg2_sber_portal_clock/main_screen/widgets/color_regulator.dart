import 'deps/get/get.dart';
import 'package:flutter/material.dart';
import 'main_screen/logic.dart';
import 'utils/my_logger.dart';

class ColorRegulator extends GetView<MainScreenLogic> {
  const ColorRegulator({super.key});

  @override
  Widget build(BuildContext context) {
    var state = controller.screenState;
    return Positioned(
      bottom: 0,
      left: 100,
      right: 100,
      child: Obx(() {
        return SliderTheme(
          data: const SliderThemeData(
            trackHeight: 2,
            activeTrackColor: Colors.transparent,
            inactiveTrackColor: Colors.transparent,
            thumbColor: Colors.transparent,
            overlayColor: Colors.white54,
          ),
          child: Slider(
            min: 0,
            max: 120,
            value: state.selectedColor,
            onChanged: (value) {
              state.selectedColor = value;
            },
          ),
        );
      }),
    );
  }
}