import 'controller/controller.dart';
import 'deps/get/get.dart';

class MyBinding extends Bindings{
  @override
  void dependencies() {

Get.put(Controller());
  }
}