// Copyright (c) 2014, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:_fe_analyzer_shared/src/parser/parser.dart' as fasta;
import '../../dart/analysis/features.dart';
import '../../dart/ast/token.dart';
import '../../dart/element/element.dart';
import '../../error/listener.dart';
import '../../source/line_info.dart';
import '../dart/analysis/experiments.dart'
    show ExperimentalFeaturesStatus;
import '../dart/ast/ast.dart';
import '../fasta/ast_builder.dart';

/// A parser used to parse tokens into an AST structure.
class Parser {
  /// The fasta parser being wrapped.
  late final fasta.Parser fastaParser;

  /// The builder which creates the analyzer AST data structures
  /// based on the Fasta parser.
  final AstBuilder astBuilder;

  Parser(
    DiagnosticReporter diagnosticReporter, {
    required FeatureSet featureSet,
    required LibraryLanguageVersion languageVersion,
    required LineInfo lineInfo,
  }) : astBuilder = AstBuilder(
         diagnosticReporter,
         diagnosticReporter.source.uri,
         true,
         featureSet,
         languageVersion,
         lineInfo,
       ) {
    fastaParser = fasta.Parser(
      astBuilder,
      experimentalFeatures: ExperimentalFeaturesStatus(featureSet),
    );
    astBuilder.parser = fastaParser;
    astBuilder.allowNativeClause = true;
  }

  CompilationUnitImpl parseCompilationUnit(Token token) {
    fastaParser.parseUnit(token);
    return astBuilder.pop() as CompilationUnitImpl;
  }

  CompilationUnitImpl parseDirectives(Token token) {
    fastaParser.parseDirectives(token);
    return astBuilder.pop() as CompilationUnitImpl;
  }
}
