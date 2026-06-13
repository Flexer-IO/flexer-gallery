import 'package:flutter/material.dart';
import 'context_menus.dart';

/// A simple wrapper widget that satisfies the [ContextMenuRegion] API which
/// expects a [Widget] for the `contextMenu` parameter. It holds a list of
/// [ContextMenuButtonConfig] objects but does not render anything itself;
/// the actual menu handling is performed by the overlay provided by the
/// package.
class _SimpleContextMenu extends StatelessWidget {
  final List<ContextMenuButtonConfig> items;

  const _SimpleContextMenu({
    Key? key,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

class GskinnerteamFlutterContextMenuPage extends StatelessWidget {
  const GskinnerteamFlutterContextMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      body: ContextMenuOverlay(
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Tap, long‑press or right‑click the boxes below to open a context menu.',
                  style: TextStyle(color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                // Box with a custom generic context menu
                ContextMenuRegion(
                  // The region requires explicit menu data; we provide the button
                  // configurations wrapped in a widget that satisfies the API.
                  contextMenu: _SimpleContextMenu(
                    items: [
                      ContextMenuButtonConfig(
                        'Red',
                        onPressed: () => _showSnackBar(context, 'Red selected'),
                      ),
                      ContextMenuButtonConfig(
                        'Green',
                        onPressed: () => _showSnackBar(context, 'Green selected'),
                      ),
                      ContextMenuButtonConfig(
                        'Blue',
                        onPressed: () => _showSnackBar(context, 'Blue selected'),
                      ),
                    ],
                  ),
                  child: Container(
                    width: 200,
                    height: 100,
                    color: Colors.deepPurple,
                    alignment: Alignment.center,
                    child: const Text(
                      'Right‑click me',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                // Demonstration of the built‑in text context menu
                const TextContextMenuDemo(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

// ---------------------------------------------------------------------------
// Helper widget that showcases the default TextContextMenu.
// ---------------------------------------------------------------------------
class TextContextMenuDemo extends StatelessWidget {
  const TextContextMenuDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return ContextMenuRegion(
      // No explicit data list is required for the text context menu region,
      // but the `contextMenu` parameter is mandatory, so we provide an empty
      // widget.
      contextMenu: const SizedBox.shrink(),
      child: const SelectableText(
        'Select this text and right‑click (or long‑press) to see the default text context menu.',
        style: TextStyle(color: Colors.white70),
      ),
    );
  }
}