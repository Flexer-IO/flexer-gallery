// Copyright (c) 2020, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:_fe_analyzer_shared/src/flow_analysis/flow_analysis.dart';
import 'package:_fe_analyzer_shared/src/types/shared_type.dart';
import '../../dart/ast/ast.dart';
import '../dart/ast/extensions.dart';
import '../dart/element/type.dart';
import '../diagnostic/diagnostic.dart' as diag;
import './codes.dart';
import './listener.dart';
import './nullable_dereference_verifier.dart';
import '../generated/resolver.dart';

/// Helper for verifying expression that should be of type bool.
class BoolExpressionVerifier {
  final ResolverVisitor _resolver;
  final DiagnosticReporter _diagnosticReporter;
  final NullableDereferenceVerifier _nullableDereferenceVerifier;

  final InterfaceTypeImpl _boolType;

  BoolExpressionVerifier({
    required ResolverVisitor resolver,
    required DiagnosticReporter diagnosticReporter,
    required NullableDereferenceVerifier nullableDereferenceVerifier,
  }) : _resolver = resolver,
       _diagnosticReporter = diagnosticReporter,
       _nullableDereferenceVerifier = nullableDereferenceVerifier,
       _boolType = resolver.typeSystem.typeProvider.boolType;

  /// Check to ensure that the [condition] is of type bool, are. Otherwise an
  /// error is reported on the expression.
  ///
  /// See [diag.nonBoolCondition].
  void checkForNonBoolCondition(
    Expression condition, {
    required Map<SharedTypeView, NonPromotionReason> Function()? whyNotPromoted,
  }) {
    checkForNonBoolExpression(
      condition,
      locatableDiagnostic: diag.nonBoolCondition,
      whyNotPromoted: whyNotPromoted,
    );
  }

  /// Verify that the given [expression] is of type 'bool', and report
  /// [locatableDiagnostic] if not, or a nullability error if its improperly
  /// nullable.
  void checkForNonBoolExpression(
    Expression expression, {
    required LocatableDiagnostic locatableDiagnostic,
    required Map<SharedTypeView, NonPromotionReason> Function()? whyNotPromoted,
  }) {
    var type = expression.typeOrThrow;
    if (!_checkForUseOfVoidResult(expression) &&
        !_resolver.typeSystem.isAssignableTo(
          type,
          _boolType,
          strictCasts: _resolver.analysisOptions.strictCasts,
        )) {
      if (type.isDartCoreBool) {
        _nullableDereferenceVerifier.report(
          diag.uncheckedUseOfNullableValueAsCondition,
          expression,
          type,
          messages: _resolver.computeWhyNotPromotedMessages(
            expression,
            whyNotPromoted?.call(),
          ),
        );
      } else {
        _diagnosticReporter.report(locatableDiagnostic.at(expression));
      }
    }
  }

  /// Checks to ensure that the given [expression] is assignable to bool.
  void checkForNonBoolNegationExpression(
    Expression expression, {
    required Map<SharedTypeView, NonPromotionReason> Function()? whyNotPromoted,
  }) {
    checkForNonBoolExpression(
      expression,
      locatableDiagnostic: diag.nonBoolNegationExpression,
      whyNotPromoted: whyNotPromoted,
    );
  }

  /// Check for situations where the result of a method or function is used,
  /// when it returns 'void'. Or, in rare cases, when other types of expressions
  /// are void, such as identifiers.
  // TODO(scheglov): Move this in a separate verifier.
  bool _checkForUseOfVoidResult(Expression expression) {
    if (expression.staticType is! VoidTypeImpl) {
      return false;
    }

    if (expression is MethodInvocation) {
      SimpleIdentifier methodName = expression.methodName;
      _diagnosticReporter.report(diag.useOfVoidResult.at(methodName));
    } else {
      _diagnosticReporter.report(diag.useOfVoidResult.at(expression));
    }

    return true;
  }
}
