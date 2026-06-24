import 'dart:io';

import '../fluent.dart';
import '../utils.dart';

String getOperatingSystemName() {
  switch (Platform.operatingSystem) {
    case 'android':
    case 'linux':
      final data = (fluent(exec('lsb_release', ['-a']))
            ..trim()
            ..stringToMap(':'))
          .mapValue;
      return fluent(data['Distributor ID']).stringValue;
    case 'macos':
      final data = (fluent(exec('sw_vers', []))
            ..trim()
            ..stringToMap(':'))
          .mapValue;
      return fluent(data['ProductName']).stringValue;
    case 'windows':
      final data = wmicGetValueAsMap('OS', ['Caption'])!;
      return fluent(data['Caption']).stringValue;
    default:
      notSupportedError();
  }
}

String getOperatingSystemVersion() {
  switch (Platform.operatingSystem) {
    case 'android':
    case 'linux':
      final data = (fluent(exec('lsb_release', ['-a']))
            ..trim()
            ..stringToMap(':'))
          .mapValue;
      return fluent(data['Release']).stringValue;
    case 'macos':
      final data = (fluent(exec('sw_vers', []))
            ..trim()
            ..stringToMap(':'))
          .mapValue;
      return fluent(data['ProductVersion']).stringValue;
    case 'windows':
      final data = wmicGetValueAsMap('OS', ['Version'])!;
      return fluent(data['Version']).stringValue;
    default:
      notSupportedError();
  }
}
