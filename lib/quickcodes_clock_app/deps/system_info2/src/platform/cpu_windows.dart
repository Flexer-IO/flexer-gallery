import 'dart:collection';

import '../core_info.dart';
import '../fluent.dart';
import '../processor_architecture.dart';
import '../utils.dart';
import 'cpu.dart';

UnmodifiableListView<CoreInfo> getWindowsCores() {
  final groups = wmicGetValueAsGroups('CPU',
      ['Architecture', 'DataWidth', 'Manufacturer', 'Name', 'NumberOfCores'])!;
  final numberOfSockets = groups.length;
  final cores = <CoreInfo>[];
  for (var i = 0; i < numberOfSockets; i++) {
    final data = groups[i];
    final numberOfCores = (fluent(data['NumberOfCores'])..parseInt()).intValue;
    var architecture = ProcessorArchitecture.unknown;
    switch ((fluent(data['Architecture'])..parseInt()).intValue) {
      case 0:
        architecture = ProcessorArchitecture.x86;
        break;
      case 1:
        architecture = ProcessorArchitecture.mips;
        break;
      case 5:
        switch ((fluent(data['DataWidth'])..parseInt()).intValue) {
          case 32:
            architecture = ProcessorArchitecture.arm;
            break;
          case 64:
            architecture = ProcessorArchitecture.arm64;
            break;
        }

        break;
      case 9:
        architecture = ProcessorArchitecture.x86_64;
        break;
    }

    for (var socket = 0; socket < numberOfCores; socket++) {
      final name = fluent(data['Name']).stringValue;
      final vendor = fluent(data['Manufacturer']).stringValue;
      final core = CoreInfo(
          architecture: architecture,
          name: name,
          socket: socket,
          vendor: vendor);
      cores.add(core);
    }
  }

  if (cores.isEmpty) {
    cores.add(createUnknownProcessor());
  }

  return UnmodifiableListView(cores);
}
