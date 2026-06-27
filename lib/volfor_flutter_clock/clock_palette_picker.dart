import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:showcase_library/showcase_contract.dart';

import 'clock_palette.dart';

class ClockPalettePicker extends StatefulWidget {
  const ClockPalettePicker({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  State<ClockPalettePicker> createState() => _ClockPalettePickerState();
}

class _ClockPalettePickerState extends State<ClockPalettePicker>
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

  void _openDrawer() {
    _timer?.cancel();
    _fade.forward();
    setState(() => _open = true);
  }

  void _closeDrawer() {
    _fade.forward();
    setState(() => _open = false);
    _scheduleFade();
  }

  void _handleTap() => _open ? _closeDrawer() : _openDrawer();

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
              accent: kClockPalettes[widget.selectedIndex].arrows,
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
    required this.accent,
    required this.onTap,
  });

  final bool open;
  final Color accent;
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
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.25),
                width: 1,
              ),
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
                if (!open)
                  Positioned(
                    top: 7,
                    right: 7,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: accent,
                        border: Border.all(color: Colors.white, width: 1.2),
                        boxShadow: [
                          BoxShadow(
                            color: accent.withValues(alpha: 0.8),
                            blurRadius: 6,
                          ),
                        ],
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

class _DrawerPanel extends StatefulWidget {
  const _DrawerPanel({
    required this.selectedIndex,
    required this.onSelected,
  });

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
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.18),
              ),
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
                _Header(count: kClockPalettes.length),
                Container(
                  height: 1,
                  color: Colors.white.withValues(alpha: 0.10),
                ),
                Flexible(
                  child: ListView.builder(
                    controller: _controller,
                    itemCount: kClockPalettes.length,
                    itemExtent: _itemExtent,
                    padding:
                        const EdgeInsets.symmetric(vertical: _listPadding),
                    itemBuilder: (context, i) => _PaletteTile(
                      palette: kClockPalettes[i],
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
              letterSpacing: 0.2,
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

  final ClockPalette palette;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
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
                color: selected ? palette.arrows : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(width: 20, height: 28, color: palette.background),
                    Container(width: 20, height: 28, color: palette.arrows),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  palette.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (selected)
                Icon(Icons.check_rounded, color: palette.arrows, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}
