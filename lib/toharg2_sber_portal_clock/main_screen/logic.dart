import 'deps/get/get.dart';
import 'main_screen/state/time_state.dart';
import 'state/screen_state.dart';

class MainScreenLogic extends GetxController {
  final MainScreenState screenState = MainScreenState();
  final TimeState timeState = TimeState();

  @override
  void onInit() {
    super.onInit();
    screenState.setBrightness();
  }


}
