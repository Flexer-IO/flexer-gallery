import 'dart:collection';

import '../core_info.dart';
import '../fluent.dart';
import '../utils.dart';
import 'cpu.dart';

UnmodifiableListView<CoreInfo> getNixCores() {
  final cores = <CoreInfo>[];
  final groups = (fluent(exec('cat', ['/proc/cpuinfo']))
        ..trim()
        ..stringToList()
        ..listToGroups(':'))
      .groupsValue!;

  final processorGroups = groups.where((e) => e.keys.contains('processor'));
  String? cpuImplementer = '';
  String? cpuPart = '';
  String? hardware = '';
  String? processorName = '';
  for (final group in groups) {
    if (cpuPart!.isEmpty) {
      cpuPart = fluent(group['CPU part']).stringValue;
    }

    if (hardware!.isEmpty) {
      hardware = fluent(group['Hardware']).stringValue;
    }

    if (cpuImplementer!.isEmpty) {
      cpuImplementer = fluent(group['CPU implementer']).stringValue;
    }

    if (processorName!.isEmpty) {
      processorName = fluent(group['Processor']).stringValue;
    }
  }

  for (final group in processorGroups) {
    int? socket = 0;
    if (fluent(group['physical id']).stringValue.isNotEmpty) {
      socket = (fluent(group['physical id'])..parseInt()).intValue;
    } else {
      socket = (fluent(group['processor'])..parseInt()).intValue;
    }

    var vendor = fluent(group['vendor_id']).stringValue;
    const modelFields = <String>['model name', 'cpu model'];
    String? name = '';
    for (final field in modelFields) {
      name = fluent(group[field]).stringValue;
      if (name.isNotEmpty) {
        break;
      }
    }

    if (name!.isEmpty) {
      name = processorName;
    }

    final architecture = getProcessorArchitecture(name!, group);

    if (vendor.isEmpty) {
      switch (cpuImplementer!.toLowerCase()) {
        case '0x51':
          vendor = 'Qualcomm';
          break;
        default:
      }
    }

    final processor = CoreInfo(
        architecture: architecture, name: name, socket: socket, vendor: vendor);
    cores.add(processor);
  }

  if (cores.isEmpty) {
    cores.add(createUnknownProcessor());
  }

  return UnmodifiableListView(cores);
}
