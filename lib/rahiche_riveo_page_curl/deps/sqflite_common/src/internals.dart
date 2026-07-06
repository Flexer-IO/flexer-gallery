import 'package:meta/meta.dart';
import '../sqlite_api.dart';
import './database_mixin.dart';
import './factory.dart';

/// Internal access to invoke method
extension DatabaseFactoryInternalsExt on DatabaseFactory {
  /// Call invoke method manually.
  @visibleForTesting
  Future<T> internalsInvokeMethod<T>(String method, Object? arguments) async {
    return (this as SqfliteDatabaseFactory).invokeMethod<T>(method, arguments);
  }
}

/// Internal access to database configuration
extension DatabaseInternalsExt on Database {
  /// Do not use synchronized to allow concurrent access
  @visibleForTesting
  set internalsDoNotUseSynchronized(bool doNotUseSynchronized) =>
      (this as SqfliteDatabaseMixin).doNotUseSynchronized =
          doNotUseSynchronized;

  /// Internal database id.
  @visibleForTesting
  int? get databaseId => (this as SqfliteDatabaseMixin).id;
}
