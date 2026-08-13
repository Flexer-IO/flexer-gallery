import 'package:flutter/foundation.dart';
import '../elements/jardinain.dart';

class JardinainController extends ChangeNotifier {
  double _jardinainHeight = 0;
  List<Jardinain> _jardinains = [];

  void setJardinains(List<Jardinain> jards) {
    _jardinains = jards;
    notifyListeners();
  }

  List<Jardinain> get jardinains => _jardinains;

  set jardinainHeight(double height) => _jardinainHeight = height;

  double get jardinainHeight => _jardinainHeight;

  void removeJardinain(int id) {
    _jardinains.removeWhere((element) => element.id == id);
    notifyListeners();
  }
}