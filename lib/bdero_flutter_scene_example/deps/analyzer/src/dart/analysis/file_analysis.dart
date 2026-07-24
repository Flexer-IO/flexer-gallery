// Copyright (c) 2024, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../../../error/listener.dart';
import './file_state.dart';
import '../ast/ast.dart';
import '../element/element.dart';
import '../element/scope.dart';
import '../../ignore_comments/ignore_info.dart';

/// Information about a file being analyzed.
class FileAnalysis {
  final FileState file;
  final RecordingDiagnosticListener diagnosticListener;
  final DiagnosticReporter diagnosticReporter;
  final CompilationUnitImpl unit;
  final LibraryFragmentImpl fragment;
  final IgnoreInfo ignoreInfo;
  final ImportsTracking importsTracking;

  FileAnalysis({
    required this.file,
    required this.diagnosticListener,
    required this.unit,
    required this.fragment,
  }) : diagnosticReporter = DiagnosticReporter(diagnosticListener, file.source),
       ignoreInfo = IgnoreInfo.forDart(unit, file.content),
       importsTracking = fragment.scope.importsTrackingInit();
}
