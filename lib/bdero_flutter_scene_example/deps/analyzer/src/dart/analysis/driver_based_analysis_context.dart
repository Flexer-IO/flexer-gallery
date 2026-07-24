// Copyright (c) 2018, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../../../dart/analysis/analysis_context.dart';
import '../../../dart/analysis/session.dart';
import '../../../file_system/file_system.dart';
import './context_root.dart';
import './driver.dart' show AnalysisDriver;
import '../sdk/sdk.dart';
import '../../generated/engine.dart'
    show AnalysisOptions, AnalysisOptionsImpl;

/// An analysis context whose implementation is based on an analysis driver.
class DriverBasedAnalysisContext implements AnalysisContext {
  /// The resource provider used to access the file system.
  final ResourceProvider resourceProvider;

  @override
  final ContextRootImpl contextRoot;

  /// The driver on which this context is based.
  late final AnalysisDriver driver;

  /// Initialize a newly created context that uses the given [resourceProvider]
  /// to access the file system and that is based on the given analysis
  /// [driver].
  DriverBasedAnalysisContext(this.resourceProvider, this.contextRoot);

  /// Get all the analysis options objects associated with this context.
  List<AnalysisOptionsImpl> get allAnalysisOptions => [
    ...driver.analysisOptionsMap.options,
  ];

  @override
  AnalysisSession get currentSession => driver.currentSession;

  @override
  Folder? get sdkRoot {
    var sdk = driver.sourceFactory.dartSdk;
    if (sdk is FolderBasedDartSdk) {
      return sdk.directory;
    }
    return null;
  }

  @override
  Future<List<String>> applyPendingFileChanges() {
    return driver.applyPendingFileChanges();
  }

  @override
  void changeFile(String path) {
    driver.changeFile(path);
  }

  @override
  AnalysisOptions getAnalysisOptionsForFile(File file) =>
      driver.getAnalysisOptionsForFile(file);
}
