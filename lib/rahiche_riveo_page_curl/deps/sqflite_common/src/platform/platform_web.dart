import '../database_file_system.dart';
import './platform.dart';

class _PlatformWeb extends Platform {
  @override
  bool get isWeb => true;

  @override
  DatabaseFileSystem get databaseFileSystem =>
      throw UnimplementedError('$runtimeType.databaseFileSystem');
}

/// Platform (Web)
final platform = _PlatformWeb();
