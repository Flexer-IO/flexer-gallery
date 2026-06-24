import 'dart:io';

import '../core_info.dart';
import '../fluent.dart';
import '../processor_architecture.dart';
import '../utils.dart';
import 'cpu_macos.dart';
import 'cpu_nix.dart';
import 'cpu_windows.dart';

CoreInfo createUnknownProcessor() => CoreInfo();

List<CoreInfo> getCores() {
  switch (Platform.operatingSystem) {
    case 'android':
    case 'linux':
      return getNixCores();
    case 'macos':
      return getMacOSCores();
    case 'windows':
      return getWindowsCores();
    default:
      notSupportedError();
  }
}

ProcessorArchitecture getProcessorArchitecture(
    String name, Map<String, String> group) {
  final uppercaseName = name.toUpperCase();
  var architecture = ProcessorArchitecture.unknown;
  if (uppercaseName.startsWith('AMD')) {
    architecture = ProcessorArchitecture.x86;
    final flags = (fluent(group['flags'])..split(' ')).listValue;
    if (flags.contains('lm')) {
      architecture = ProcessorArchitecture.x86_64;
    }
  } else if (uppercaseName.startsWith('Intel')) {
    architecture = ProcessorArchitecture.x86;
    final flags = (fluent(group['flags'])..split(' ')).listValue;
    if (flags.contains('lm')) {
      architecture = ProcessorArchitecture.x86_64;
    }

    if (flags.contains('ia64')) {
      architecture = ProcessorArchitecture.ia64;
    }
  } else if (uppercaseName.startsWith('ARM')) {
    architecture = ProcessorArchitecture.arm;
    final features = (fluent(group['Features'])..split(' ')).listValue;
    if (features.contains('fp')) {
      architecture = ProcessorArchitecture.arm64;
    }
  } else if (uppercaseName.toUpperCase().startsWith('AARCH64')) {
    architecture = ProcessorArchitecture.arm64;
  } else if (uppercaseName.startsWith('MIPS')) {
    architecture = ProcessorArchitecture.mips;
  }
  return architecture;
}
