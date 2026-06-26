import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:showcase_library/showcase_contract.dart';

import 'constants.dart';

class SnakePalettePicker extends StatefulWidget {
  const SnakePalettePicker({
    super.key,
    required this.palettes,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<SnakePalette> palettes;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  State<SnakePalettePicker> createState() => _SnakePalettePickerState();
}

class _SnakePalettePickerState extends State<SnakePalettePicker>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fade;
  Timer? _timer;
  bool _open = false;

  @override
  void initState() {
    super.initState();
    _fade = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
      value: 1.0,
    );
    _scheduleFade();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _fade.dispose();
    super.dispose();
  }

  void _scheduleFade() {
    _timer?.cancel();
    if (_open) return;
    _timer = Timer(const Duration(seconds: 3), () {
      if (mounted && !_open) _fade.reverse();
    });
  }

  void _handleTap() {
    _timer?.cancel();
    _fade.forward();
    setState(() => _open = !_open);
    if (!_open) _scheduleFade();
  }

  @override
  Widget build(BuildContext context) {
    final safePad = MediaQuery.paddingOf(context);
    return Positioned(
      top: safePad.top + 16,
      right: safePad.right + 12,
      child: AnimatedBuilder(
        animation: _fade,
        builder: (context, child) =>
            Opacity(opacity: _open ? 1.0 : _fade.value, child: child),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _TriggerButton(
              open: _open,
              bodyColor:
                  widget.palettes[widget.selectedIndex].colors[Entity.body],
              onTap: _handleTap,
            ),
            if (_open) ...[
              const SizedBox(height: 10),
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                builder: (context, t, child) => Opacity(
                  opacity: t,
                  child: Transform.scale(
                    scale: 0.92 + 0.08 * t,
                    alignment: Alignment.topRight,
                    child: child,
                  ),
                ),
                child: _DrawerPanel(
                  palettes: widget.palettes,
                  selectedIndex: widget.selectedIndex,
                  onSelected: widget.onSelected,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _TriggerButton extends StatelessWidget {
  const _TriggerButton({
    required this.open,
    required this.bodyColor,
    required this.onTap,
  });

  final bool open;
  final Color? bodyColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withValues(alpha: 0.18),
                  Colors.white.withValues(alpha: 0.04),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.35),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder: (child, anim) =>
                      ScaleTransition(scale: anim, child: child),
                  child: Icon(
                    open ? Icons.close_rounded : Icons.palette_rounded,
                    key: ValueKey(open),
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                if (!open && bodyColor != null)
                  Positioned(
                    top: 7,
                    right: 7,
                    child: _ColorDot(color: bodyColor!),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ColorDot extends StatelessWidget {
  const _ColorDot({required this.color});
  final Color color;
  static const double size = 10;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        border: Border.all(color: Colors.white, width: 1.2),
        boxShadow: [
          BoxShadow(color: color.withValues(alpha: 0.8), blurRadius: 6),
        ],
      ),
    );
  }
}

class _DrawerPanel extends StatefulWidget {
  const _DrawerPanel({
    required this.palettes,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<SnakePalette> palettes;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  State<_DrawerPanel> createState() => _DrawerPanelState();
}

class _DrawerPanelState extends State<_DrawerPanel> {
  static const _itemExtent = 52.0;
  static const _listPadding = 8.0;
  final _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_controller.hasClients) return;
      final itemCenter =
          _listPadding + widget.selectedIndex * _itemExtent + _itemExtent / 2;
      final viewport = _controller.position.viewportDimension;
      final target = (itemCenter - viewport / 2).clamp(
        0.0,
        _controller.position.maxScrollExtent,
      );
      _controller.animateTo(
        target,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerPanZoomStart: (_) =>
          const ShowcasePopVetoNotification().dispatch(context),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            width: 220,
            constraints: BoxConstraints(
              maxHeight: MediaQuery.sizeOf(context).height * 0.72,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withValues(alpha: 0.10),
                  Colors.black.withValues(alpha: 0.32),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.45),
                  blurRadius: 24,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _Header(count: widget.palettes.length),
                Container(
                  height: 1,
                  color: Colors.white.withValues(alpha: 0.10),
                ),
                Flexible(
                  child: ListView.builder(
                    controller: _controller,
                    itemCount: widget.palettes.length,
                    itemExtent: _itemExtent,
                    padding: const EdgeInsets.symmetric(vertical: _listPadding),
                    itemBuilder: (context, i) => _PaletteTile(
                      palette: widget.palettes[i],
                      selected: widget.selectedIndex == i,
                      onTap: () => widget.onSelected(i),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.count});
  final int count;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 12, 12),
      child: Row(
        children: [
          const Icon(Icons.palette_rounded, color: Colors.white, size: 18),
          const SizedBox(width: 8),
          const Text(
            'Palette',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$count',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.85),
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PaletteTile extends StatelessWidget {
  const _PaletteTile({
    required this.palette,
    required this.selected,
    required this.onTap,
  });

  final SnakePalette palette;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bodyColor = palette.colors[Entity.body];
    final accent = bodyColor ?? Colors.white;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: selected ? Colors.white.withValues(alpha: 0.10) : null,
            border: Border(
              left: BorderSide(
                color: selected ? accent : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      palette.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          for (final key in [
                            Entity.background,
                            Entity.body,
                            Entity.indications,
                            Entity.leaf,
                          ])
                            if (palette.colors[key] != null)
                              Container(
                                width: 16,
                                height: 12,
                                color: palette.colors[key],
                              ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (selected) Icon(Icons.check_rounded, color: accent, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}
