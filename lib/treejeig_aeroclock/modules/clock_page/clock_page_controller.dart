import 'package:flutter/material.dart';
import 'deps/flutter_riverpod/flutter_riverpod.dart';

import '../../models/global_variables.dart';


final clockPageProvider = ChangeNotifierProvider<ClockPageController>((ref){
  return ClockPageController();
});

class ClockPageController extends ChangeNotifier {

}