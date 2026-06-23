// Copyright (c) 2015, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../../dart/analysis/analysis_options.dart';
import '../../dart/analysis/declared_variables.dart';
import '../../file_system/file_system.dart';
import '../dart/analysis/analysis_options.dart';
import '../dart/analysis/analysis_options_map.dart';
import '../dart/element/type_provider.dart';
import '../dart/element/type_system.dart';
import '../generated/engine.dart' show AnalysisContext;
import '../generated/source.dart';

/// An [AnalysisContext] in which analysis can be performed.
class AnalysisContextImpl implements AnalysisContext {
  AnalysisOptionsMap _analysisOptionsMap;

  @override
  final DeclaredVariables declaredVariables;

  @override
  final SourceFactory sourceFactory;

  TypeProviderImpl? _typeProvider;
  TypeSystemImpl? _typeSystem;

  AnalysisContextImpl({
    required AnalysisOptionsMap analysisOptionsMap,
    required this.declaredVariables,
    required this.sourceFactory,
  }) : _analysisOptionsMap = analysisOptionsMap;

  // TODO(scheglov): Remove it, exists only for Cider.
  set analysisOptions(AnalysisOptionsImpl analysisOptions) {
    _analysisOptionsMap = AnalysisOptionsMap.forSharedOptions(analysisOptions);
  }

  bool get hasTypeProvider {
    return _typeProvider != null;
  }

  TypeProviderImpl get typeProvider {
    return _typeProvider!;
  }

  TypeSystemImpl get typeSystem {
    return _typeSystem!;
  }

  void clearTypeProvider() {
    _typeProvider = null;
    _typeSystem = null;
  }

  @override
  AnalysisOptions getAnalysisOptionsForFile(File file) =>
      _analysisOptionsMap[file];

  void setTypeProviders({required TypeProviderImpl typeProvider}) {
    if (_typeProvider != null) {
      throw StateError('TypeProvider can be set only once.');
    }

    _typeProvider = typeProvider;

    _typeSystem = TypeSystemImpl(typeProvider: typeProvider);
  }
}
