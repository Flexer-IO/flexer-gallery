import 'package:flutter/material.dart' hide RootWidget;

// Import the term model using a package import (ensures correct resolution)
import 'package:marcelgarus_math_clock/marcelgarus_math_clock/term.dart';

// Package imports for widget implementations
import 'package:marcelgarus_math_clock/marcelgarus_math_clock/term_widgets/parenthesis_widget.dart';
import 'package:marcelgarus_math_clock/marcelgarus_math_clock/term_widgets/number_widget.dart';
import 'package:marcelgarus_math_clock/marcelgarus_math_clock/term_widgets/add_widget.dart';
import 'package:marcelgarus_math_clock/marcelgarus_math_clock/term_widgets/subtract_widget.dart';
import 'package:marcelgarus_math_clock/marcelgarus_math_clock/term_widgets/multiply_widget.dart';
import 'package:marcelgarus_math_clock/marcelgarus_math_clock/term_widgets/divide_widget.dart';
import 'package:marcelgarus_math_clock/marcelgarus_math_clock/term_widgets/modulo_widget.dart';
import 'package:marcelgarus_math_clock/marcelgarus_math_clock/term_widgets/squared_widget.dart';
import 'package:marcelgarus_math_clock/marcelgarus_math_clock/term_widgets/cubed_widget.dart';
import 'package:marcelgarus_math_clock/marcelgarus_math_clock/term_widgets/factorial_widget.dart';
import 'package:marcelgarus_math_clock/marcelgarus_math_clock/term_widgets/root_widget.dart';

export 'package:marcelgarus_math_clock/marcelgarus_math_clock/theme.dart';

/// A widget that displays the given [term].
/// Optionally, you can also provide a set of [typesToParenthesise]. If the
/// widget's runtime type is included into the [typesToParenthesise], the term
/// is wrapped in a [ParenthesisWidget].
class TermWidget extends StatelessWidget {
  const TermWidget({
    Key? key,
    required this.term,
    this.typesToParenthesise = const {},
  }) : super(key: key);

  final Term term;
  Term get first => term.children.first;
  Term get second => term.children[1];

  final Set<Type> typesToParenthesise;

  @override
  Widget build(BuildContext context) {
    if (typesToParenthesise.contains(term.runtimeType)) {
      return ParenthesisWidget(term: term);
    }

    // Use runtime type name strings to avoid direct class references,
    // keeping the widget compatible with null‑safety and Dart 3.
    final typeName = term.runtimeType.toString();

    if (typeName == 'Number') {
      return NumberWidget(term: term);
    } else if (typeName == 'Add') {
      return AddWidget(term: term);
    } else if (typeName == 'Subtract') {
      return SubtractWidget(term: term);
    } else if (typeName == 'Multiply') {
      return MultiplyWidget(term: term);
    } else if (typeName == 'Divide') {
      return DivideWidget(term: term);
    } else if (typeName == 'Modulo') {
      return ModuloWidget(term: term);
    } else if (typeName == 'Squared') {
      return SquaredWidget(term: term);
    } else if (typeName == 'Cubed') {
      return CubedWidget(term: term);
    } else if (typeName == 'Factorial') {
      return FactorialWidget(term: term);
    } else if (typeName == 'Root') {
      return RootWidget(term: term);
    } else {
      return Text('unknown type ${term.runtimeType}');
    }
  }
}