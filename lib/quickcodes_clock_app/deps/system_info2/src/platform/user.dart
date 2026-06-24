import 'dart:io';

import '../fluent.dart';
import '../system_info.dart';
import '../utils.dart';

String getUserDirectory() {
  switch (Platform.operatingSystem) {
    case 'android':
    case 'linux':
    case 'macos':
      return fluent(Platform.environment['HOME']).stringValue;
    case 'windows':
      return fluent(Platform.environment['USERPROFILE']).stringValue;
    default:
      notSupportedError();
  }
}

String getUserId() {
  switch (Platform.operatingSystem) {
    case 'android':
    case 'linux':
    case 'macos':
      return (fluent(exec('id', ['-u']))..trim()).stringValue;
    case 'windows':
      final data = wmicGetValueAsMap('UserAccount', ['SID'],
          where: ["Name='${SysInfo.userName}'"])!;
      return fluent(data['SID']).stringValue;
    default:
      notSupportedError();
  }
}

String getUserName() {
  switch (Platform.operatingSystem) {
    case 'android':
    case 'linux':
    case 'macos':
      return (fluent(exec('whoami', []))..trim()).stringValue;
    case 'windows':
      final data = wmicGetValueAsMap('ComputerSystem', ['UserName'])!;
      return (fluent(data['UserName'])
            ..split(r'\')
            ..last())
          .stringValue;
    default:
      notSupportedError();
  }
}
