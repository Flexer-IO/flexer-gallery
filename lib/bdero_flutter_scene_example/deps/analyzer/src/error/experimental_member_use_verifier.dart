// Copyright (c) 2025, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../../dart/ast/syntactic_entity.dart';
import '../../dart/element/element.dart';
import '../diagnostic/diagnostic.dart' as diag;
import './element_usage_detector.dart';
import './listener.dart';

/// Instance of [ElementUsageReporter] for reporting uses of experimental
/// elements.
class ExperimentalElementUsageReporter implements ElementUsageReporter<()> {
  final DiagnosticReporter _diagnosticReporter;

  ExperimentalElementUsageReporter({
    required DiagnosticReporter diagnosticReporter,
  }) : _diagnosticReporter = diagnosticReporter;

  @override
  void report(
    SyntacticEntity errorEntity,
    String displayName,
    () tagInfo, {
    required bool isInSamePackage,
  }) {
    // Use of an experimental API from within the same package is OK
    if (isInSamePackage) return;

    _diagnosticReporter.report(
      diag.experimentalMemberUse
          .withArguments(member: displayName)
          .at(errorEntity),
    );
  }
}

/// Instance of [ElementUsageSet] for experimental elements.
class ExperimentalElementUsageSet implements ElementUsageSet<()> {
  const ExperimentalElementUsageSet();

  @override
  bool get reliesOnlyOnElementMetadata => true;

  @override
  ()? getTagInfo(Element _, Metadata elementMetadata) =>
      elementMetadata.annotations.any((e) => e.isExperimental) ? () : null;
}
