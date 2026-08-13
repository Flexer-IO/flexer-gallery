import 'package:get_it/get_it.dart';
import 'jardinain_controller.dart';

final GetIt getIt = GetIt.instance;

void initiateSL() {
  getIt.registerSingleton<JardinainController>(JardinainController());
}