import 'dart:io';

import '../fluent.dart';
import '../utils.dart';
import 'kernel.dart';

int getUserSpaceBitness() {
  switch (Platform.operatingSystem) {
    case 'android':
    case 'linux':
      return (fluent(exec('getconf', ['LONG_BIT']))
            ..trim()
            ..parseInt())
          .intValue;
    case 'macos':
      if (Platform.version.contains('macos_ia32')) {
        return 32;
      } else if (Platform.version.contains('macos_x64')) {
        return 64;
      } else {
        return getKernelBitness();
      }
    case 'windows':
      final wow64 =
          fluent(Platform.environment['PROCESSOR_ARCHITEW6432']).stringValue;
      if (wow64.isNotEmpty) {
        return 32;
      }

      switch (Platform.environment['PROCESSOR_ARCHITECTURE']) {
        case 'AMD64':
        case 'IA64':
          return 64;
      }

      return 32;
    default:
      notSupportedError();
  }
}
