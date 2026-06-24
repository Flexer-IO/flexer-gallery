import 'dart:collection';

import '../core_info.dart';
import '../fluent.dart';
import '../processor_architecture.dart';
import '../utils.dart';
import 'cpu.dart';

UnmodifiableListView<CoreInfo> getMacOSCores() {
  final data = (fluent(exec('sysctl', ['machdep.cpu']))
        ..trim()
        ..stringToMap(':'))
      .mapValue;
  var architecture = ProcessorArchitecture.unknown;
  if (data['machdep.cpu.vendor'] == 'GenuineIntel') {
    architecture = ProcessorArchitecture.x86;
    final extfeatures =
        (fluent(data['machdep.cpu.extfeatures'])..split(' ')).listValue;
    if (extfeatures.contains('EM64T')) {
      architecture = ProcessorArchitecture.x86_64;
    }
  }

  final numberOfCores =
      (fluent(data['machdep.cpu.core_count'])..parseInt()).intValue;
  final processors = <CoreInfo>[];
  for (var i = 0; i < numberOfCores; i++) {
    final name = fluent(data['machdep.cpu.brand_string']).stringValue;
    final vendor = fluent(data['machdep.cpu.vendor']).stringValue;
    final processor =
        CoreInfo(architecture: architecture, name: name, vendor: vendor);
    processors.add(processor);
  }

  if (processors.isEmpty) {
    processors.add(createUnknownProcessor());
  }

  return UnmodifiableListView(processors);
}
