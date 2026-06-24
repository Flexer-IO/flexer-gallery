import 'package:flutter/material.dart';
import 'package:marcelgarus_math_clock/term.dart' as term_pkg;

import 'term_widget.dart';
import 'tight_text.dart';

/// Renders a single [Number].
class NumberWidget extends TermWidget {
  const NumberWidget({required super.term}) : super();

  @override
  Widget build(BuildContext context) {
    final term_pkg.Number numberTerm = term as term_pkg.Number;
    return TightText('${numberTerm.number}');
  }
}