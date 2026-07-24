// Copyright (c) 2021, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../../dart/ast/token.dart';
import '../../dart/ast/visitor.dart';
import '../dart/ast/ast.dart';
import '../dart/ast/token.dart';

const _notSerializableName = '_notSerializableExpression';

bool isNotSerializableMarker(SimpleIdentifier node) {
  return node.name == _notSerializableName;
}

/// If [node] is fully serializable, returns it.
/// Otherwise returns a marker node.
ExpressionImpl replaceNotSerializableExpression(ExpressionImpl node) {
  var visitor = _IsSerializableNodeVisitor();
  node.accept(visitor);
  if (visitor.result) {
    return node;
  }
  return SimpleIdentifierImpl(
    token: StringToken(TokenType.STRING, _notSerializableName, -1),
  );
}

class _IsSerializableNodeVisitor extends RecursiveAstVisitor<void> {
  bool result = true;

  @override
  void visitForElement(ForElement node) {
    result = false;
  }

  @override
  void visitFunctionExpression(FunctionExpression node) {
    result = false;
  }

  @override
  void visitPatternAssignment(PatternAssignment node) {
    result = false;
  }

  @override
  void visitSwitchExpression(SwitchExpression node) {
    result = false;
  }
}
