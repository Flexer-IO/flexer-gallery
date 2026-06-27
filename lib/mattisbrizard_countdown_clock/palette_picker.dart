import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:showcase_library/showcase_contract.dart';

class CountdownPalette {
  final String name;
  final Color bg;
  final Color remaining;
  final Color elapsed;
  final Color highlight;

  const CountdownPalette({
    required this.name,
    required this.bg,
    required this.remaining,
    required this.elapsed,
    required this.highlight,
  });

  List<Color> get swatch => [bg, remaining, elapsed, highlight];
}

const kCountdownPalettes = <CountdownPalette>[
  // ── Originals ────────────────────────────────────────────────
  CountdownPalette(
    name: 'Midnight',
    bg: Color(0xFF000000),
    remaining: Color(0xFFFFFFFF),
    elapsed: Color(0x1FFFFFFF),
    highlight: Color(0xFF05827D),
  ),
  CountdownPalette(
    name: 'Crimson',
    bg: Color(0xFF0D0000),
    remaining: Color(0xFFFF4444),
    elapsed: Color(0x30FF1111),
    highlight: Color(0xFFFF8C00),
  ),
  CountdownPalette(
    name: 'Nebula',
    bg: Color(0xFF0A0018),
    remaining: Color(0xFFCC66FF),
    elapsed: Color(0x258800FF),
    highlight: Color(0xFFFF44DD),
  ),
  CountdownPalette(
    name: 'Ocean',
    bg: Color(0xFF000D1A),
    remaining: Color(0xFF44AAFF),
    elapsed: Color(0x250055FF),
    highlight: Color(0xFF00FFEE),
  ),
  CountdownPalette(
    name: 'Forest',
    bg: Color(0xFF001500),
    remaining: Color(0xFF33FF77),
    elapsed: Color(0x2500FF44),
    highlight: Color(0xFFFFEE00),
  ),
  CountdownPalette(
    name: 'Ember',
    bg: Color(0xFF110400),
    remaining: Color(0xFFFF7733),
    elapsed: Color(0x25FF3300),
    highlight: Color(0xFFFFD700),
  ),
  CountdownPalette(
    name: 'Steel',
    bg: Color(0xFF080810),
    remaining: Color(0xFFB8C4D8),
    elapsed: Color(0x257080A0),
    highlight: Color(0xFF6699FF),
  ),
  CountdownPalette(
    name: 'Rose',
    bg: Color(0xFF120008),
    remaining: Color(0xFFFF77AA),
    elapsed: Color(0x25FF0055),
    highlight: Color(0xFFFF99CC),
  ),

  // ── Dark monochromes ─────────────────────────────────────────
  CountdownPalette(
    name: 'Obsidian',
    bg: Color(0xFF0A0A0A),
    remaining: Color(0xFFE0E0E0),
    elapsed: Color(0x22E0E0E0),
    highlight: Color(0xFFAAAAAA),
  ),
  CountdownPalette(
    name: 'Charcoal',
    bg: Color(0xFF111111),
    remaining: Color(0xFFCCCCCC),
    elapsed: Color(0x20CCCCCC),
    highlight: Color(0xFF888888),
  ),
  CountdownPalette(
    name: 'Void',
    bg: Color(0xFF000000),
    remaining: Color(0xFF333333),
    elapsed: Color(0x14222222),
    highlight: Color(0xFF555555),
  ),

  // ── Blues ────────────────────────────────────────────────────
  CountdownPalette(
    name: 'Abyss',
    bg: Color(0xFF00060F),
    remaining: Color(0xFF1E90FF),
    elapsed: Color(0x251E4EFF),
    highlight: Color(0xFF00D4FF),
  ),
  CountdownPalette(
    name: 'Arctic',
    bg: Color(0xFF000A14),
    remaining: Color(0xFF88DDFF),
    elapsed: Color(0x2244AADD),
    highlight: Color(0xFFAAEEFF),
  ),
  CountdownPalette(
    name: 'Cobalt',
    bg: Color(0xFF000518),
    remaining: Color(0xFF4466FF),
    elapsed: Color(0x252233CC),
    highlight: Color(0xFF88AAFF),
  ),
  CountdownPalette(
    name: 'Navy',
    bg: Color(0xFF000510),
    remaining: Color(0xFF3355AA),
    elapsed: Color(0x222244AA),
    highlight: Color(0xFF5599FF),
  ),

  // ── Greens ───────────────────────────────────────────────────
  CountdownPalette(
    name: 'Matrix',
    bg: Color(0xFF000A00),
    remaining: Color(0xFF00FF41),
    elapsed: Color(0x2500CC33),
    highlight: Color(0xFF39FF14),
  ),
  CountdownPalette(
    name: 'Jade',
    bg: Color(0xFF000E08),
    remaining: Color(0xFF00C896),
    elapsed: Color(0x2200AA78),
    highlight: Color(0xFF00FFCC),
  ),
  CountdownPalette(
    name: 'Moss',
    bg: Color(0xFF060E00),
    remaining: Color(0xFF7EC850),
    elapsed: Color(0x225A9030),
    highlight: Color(0xFFB8FF66),
  ),
  CountdownPalette(
    name: 'Sage',
    bg: Color(0xFF050A04),
    remaining: Color(0xFF8FC99A),
    elapsed: Color(0x226A997A),
    highlight: Color(0xFFBBEEBB),
  ),

  // ── Reds & oranges ──────────────────────────────────────────
  CountdownPalette(
    name: 'Inferno',
    bg: Color(0xFF0E0000),
    remaining: Color(0xFFFF2200),
    elapsed: Color(0x28CC1100),
    highlight: Color(0xFFFF9900),
  ),
  CountdownPalette(
    name: 'Lava',
    bg: Color(0xFF0F0400),
    remaining: Color(0xFFFF6600),
    elapsed: Color(0x26CC4400),
    highlight: Color(0xFFFFCC00),
  ),
  CountdownPalette(
    name: 'Rust',
    bg: Color(0xFF0E0500),
    remaining: Color(0xFFCC5522),
    elapsed: Color(0x22993311),
    highlight: Color(0xFFFFAA44),
  ),
  CountdownPalette(
    name: 'Volcano',
    bg: Color(0xFF0A0000),
    remaining: Color(0xFFFF3300),
    elapsed: Color(0x26FF1100),
    highlight: Color(0xFFFF7700),
  ),

  // ── Purples & pinks ─────────────────────────────────────────
  CountdownPalette(
    name: 'Aurora',
    bg: Color(0xFF050010),
    remaining: Color(0xFF9933FF),
    elapsed: Color(0x266600CC),
    highlight: Color(0xFFFF44FF),
  ),
  CountdownPalette(
    name: 'Candy',
    bg: Color(0xFF100010),
    remaining: Color(0xFFFF55CC),
    elapsed: Color(0x26DD0099),
    highlight: Color(0xFFFF99EE),
  ),
  CountdownPalette(
    name: 'Dusk',
    bg: Color(0xFF08000F),
    remaining: Color(0xFF7755AA),
    elapsed: Color(0x22553388),
    highlight: Color(0xFFBB88FF),
  ),
  CountdownPalette(
    name: 'Grape',
    bg: Color(0xFF0A0015),
    remaining: Color(0xFF8844CC),
    elapsed: Color(0x22551199),
    highlight: Color(0xFFCC88FF),
  ),
  CountdownPalette(
    name: 'Magenta',
    bg: Color(0xFF0F000F),
    remaining: Color(0xFFFF00FF),
    elapsed: Color(0x28CC00CC),
    highlight: Color(0xFFFF88FF),
  ),

  // ── Cyans & teals ───────────────────────────────────────────
  CountdownPalette(
    name: 'Neon',
    bg: Color(0xFF000F0F),
    remaining: Color(0xFF00FFFF),
    elapsed: Color(0x2500CCCC),
    highlight: Color(0xFF88FFEE),
  ),
  CountdownPalette(
    name: 'Glacier',
    bg: Color(0xFF000D0F),
    remaining: Color(0xFF44DDCC),
    elapsed: Color(0x2222AAAA),
    highlight: Color(0xFF88FFFF),
  ),
  CountdownPalette(
    name: 'Teal',
    bg: Color(0xFF000C0C),
    remaining: Color(0xFF009999),
    elapsed: Color(0x22007777),
    highlight: Color(0xFF00FFDD),
  ),

  // ── Warm neutrals ───────────────────────────────────────────
  CountdownPalette(
    name: 'Sepia',
    bg: Color(0xFF0C0800),
    remaining: Color(0xFFCC9966),
    elapsed: Color(0x22996633),
    highlight: Color(0xFFFFCC88),
  ),
  CountdownPalette(
    name: 'Gold',
    bg: Color(0xFF0A0800),
    remaining: Color(0xFFFFCC00),
    elapsed: Color(0x26CC9900),
    highlight: Color(0xFFFFEE66),
  ),
  CountdownPalette(
    name: 'Amber',
    bg: Color(0xFF0C0700),
    remaining: Color(0xFFFFAA00),
    elapsed: Color(0x26CC7700),
    highlight: Color(0xFFFFDD44),
  ),
  CountdownPalette(
    name: 'Bronze',
    bg: Color(0xFF0C0600),
    remaining: Color(0xFFAA7733),
    elapsed: Color(0x22885511),
    highlight: Color(0xFFDDAA55),
  ),
  CountdownPalette(
    name: 'Copper',
    bg: Color(0xFF0D0500),
    remaining: Color(0xFFCC7744),
    elapsed: Color(0x22994422),
    highlight: Color(0xFFFFAA66),
  ),

  // ── Exotic ──────────────────────────────────────────────────
  CountdownPalette(
    name: 'Biolum',
    bg: Color(0xFF000A08),
    remaining: Color(0xFF00FF88),
    elapsed: Color(0x2200CC66),
    highlight: Color(0xFF88FFDD),
  ),
  CountdownPalette(
    name: 'Solar',
    bg: Color(0xFF0A0800),
    remaining: Color(0xFFFFDD00),
    elapsed: Color(0x26FFAA00),
    highlight: Color(0xFFFF6600),
  ),
  CountdownPalette(
    name: 'Plasma',
    bg: Color(0xFF080010),
    remaining: Color(0xFFFF00AA),
    elapsed: Color(0x26CC0077),
    highlight: Color(0xFF00FFFF),
  ),
  CountdownPalette(
    name: 'Prism',
    bg: Color(0xFF080808),
    remaining: Color(0xFFFF4488),
    elapsed: Color(0x22AA1155),
    highlight: Color(0xFF44FFCC),
  ),
  CountdownPalette(
    name: 'Toxic',
    bg: Color(0xFF040A00),
    remaining: Color(0xFFAAFF00),
    elapsed: Color(0x2277CC00),
    highlight: Color(0xFFFFFF00),
  ),
  CountdownPalette(
    name: 'Deep Sea',
    bg: Color(0xFF000510),
    remaining: Color(0xFF0055AA),
    elapsed: Color(0x22003388),
    highlight: Color(0xFF00AAFF),
  ),
  CountdownPalette(
    name: 'Afterglow',
    bg: Color(0xFF0A0510),
    remaining: Color(0xFFFF6699),
    elapsed: Color(0x22CC3366),
    highlight: Color(0xFFFFCC00),
  ),
  CountdownPalette(
    name: 'Neon Mint',
    bg: Color(0xFF000D08),
    remaining: Color(0xFF00FFAA),
    elapsed: Color(0x2200CC88),
    highlight: Color(0xFFFFFF44),
  ),
  CountdownPalette(
    name: 'Ultraviolet',
    bg: Color(0xFF040010),
    remaining: Color(0xFF7700FF),
    elapsed: Color(0x225500CC),
    highlight: Color(0xFFBB55FF),
  ),
  CountdownPalette(
    name: 'Retrowave',
    bg: Color(0xFF0A0014),
    remaining: Color(0xFFFF2277),
    elapsed: Color(0x26CC0055),
    highlight: Color(0xFF00EEFF),
  ),
  CountdownPalette(
    name: 'Moonstone',
    bg: Color(0xFF070710),
    remaining: Color(0xFFAABBDD),
    elapsed: Color(0x228899BB),
    highlight: Color(0xFFDDEEFF),
  ),
  CountdownPalette(
    name: 'Sakura',
    bg: Color(0xFF100008),
    remaining: Color(0xFFFFAABB),
    elapsed: Color(0x22DD7788),
    highlight: Color(0xFFFFCCDD),
  ),
  CountdownPalette(
    name: 'Sunset',
    bg: Color(0xFF100500),
    remaining: Color(0xFFFF6633),
    elapsed: Color(0x26EE3300),
    highlight: Color(0xFFFFCC55),
  ),
  CountdownPalette(
    name: 'Deep Space',
    bg: Color(0xFF000005),
    remaining: Color(0xFF334466),
    elapsed: Color(0x20223355),
    highlight: Color(0xFF6688CC),
  ),
];

class CountdownPalettePicker extends StatefulWidget {
  const CountdownPalettePicker({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  State<CountdownPalettePicker> createState() => _CountdownPalettePickerState();
}

class _CountdownPalettePickerState extends State<CountdownPalettePicker>
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
              highlight: kCountdownPalettes[widget.selectedIndex].highlight,
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
    required this.highlight,
    required this.onTap,
  });

  final bool open;
  final Color highlight;
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
                        color: highlight,
                        border: Border.all(color: Colors.white, width: 1.2),
                        boxShadow: [
                          BoxShadow(
                            color: highlight.withValues(alpha: 0.8),
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
  const _DrawerPanel({required this.selectedIndex, required this.onSelected});

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  State<_DrawerPanel> createState() => _DrawerPanelState();
}

class _DrawerPanelState extends State<_DrawerPanel> {
  static const _itemExtent = 64.0;
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
                _Header(count: kCountdownPalettes.length),
                Container(
                  height: 1,
                  color: Colors.white.withValues(alpha: 0.10),
                ),
                Flexible(
                  child: ListView.builder(
                    controller: _controller,
                    itemCount: kCountdownPalettes.length,
                    itemExtent: _itemExtent,
                    padding: const EdgeInsets.symmetric(vertical: _listPadding),
                    itemBuilder: (context, i) => _PaletteTile(
                      palette: kCountdownPalettes[i],
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

  final CountdownPalette palette;
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
                color: selected ? palette.highlight : Colors.transparent,
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
                          _Swatch(color: palette.bg),
                          _Swatch(color: palette.remaining),
                          _Swatch(
                            color: Color.fromARGB(
                              120,
                              palette.elapsed.r.toInt(),
                              palette.elapsed.g.toInt(),
                              palette.elapsed.b.toInt(),
                            ),
                          ),
                          _Swatch(color: palette.highlight),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (selected)
                Icon(Icons.check_rounded, color: palette.highlight, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}

class _Swatch extends StatelessWidget {
  const _Swatch({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(width: 18, height: 18, color: color);
  }
}
