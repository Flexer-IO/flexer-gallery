import '../../../extensions.dart';
import '../../anchor.dart';
import '../../../text.dart';

/// [TextRenderer] is an abstract interface for a class that can convert an
/// arbitrary string of text into a renderable [InlineTextElement].
abstract class TextRenderer {
  InlineTextElement format(String text);

  LineMetrics getLineMetrics(String text) {
    return format(text).metrics;
  }

  void render(
    Canvas canvas,
    String text,
    Vector2 position, {
    Anchor anchor = Anchor.topLeft,
  }) {
    format(text).render(canvas, position, anchor: anchor);
  }
}
