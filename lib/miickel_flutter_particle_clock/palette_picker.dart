import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:showcase_library/showcase_contract.dart';

import 'bg_fx.dart';
import 'clock_bg_particle_painter.dart';
import 'clock_face_painter.dart';
import 'clock_fx_painter.dart';
import 'clock_seconds_painter.dart';
import 'palette.dart';
import 'particle_clock_fx.dart';
import 'utils/rnd.dart';

/// The accent the clock derives from [colors]: the colour furthest from the
/// background (first colour) in luminance.
Color _accentOf(List<Color> colors) {
  if (colors.isEmpty) return Colors.white;
  final bgLum = colors.first.computeLuminance();
  var accent = colors.last;
  var maxDiff = -1.0;
  for (final c in colors) {
    final diff = (bgLum - c.computeLuminance()).abs();
    if (diff > maxDiff) {
      maxDiff = diff;
      accent = c;
    }
  }
  return accent;
}

/// A right-side, frosted-glass drawer that lets the user lock the particle
/// clock to a single palette, browse every palette, or fall back to "All"
/// (the default random rotation).
///
/// Like the showcase back button it auto-hides a few seconds after the last
/// interaction; a tap brings it back. It sits on the opposite side.
class PalettePicker extends StatefulWidget {
  const PalettePicker({
    super.key,
    required this.palettes,
    required this.selectedIndex,
    required this.mode,
    required this.onSelected,
    required this.onModeSelected,
  });

  final List<Palette> palettes;

  /// The locked palette index, or null when rotating per [mode].
  final int? selectedIndex;

  /// Active rotation mode (used when [selectedIndex] is null).
  final PaletteMode mode;

  final ValueChanged<int> onSelected;
  final ValueChanged<PaletteMode> onModeSelected;

  @override
  State<PalettePicker> createState() => _PalettePickerState();
}

class _PalettePickerState extends State<PalettePicker>
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
    if (_open) return; // Stay put while the drawer is open.
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

  // A tap always opens (or closes) — no fragile "reveal first" stage that
  // could swallow the tap mid-fade.
  void _handleTap() => _open ? _closeDrawer() : _openDrawer();

  // Selection keeps the drawer open so the user can browse/compare palettes
  // and modes without it dismissing each time. Tapping the trigger closes it.
  void _select(int index) => widget.onSelected(index);

  void _selectMode(PaletteMode mode) => widget.onModeSelected(mode);

  Color? _selectedAccent() {
    final i = widget.selectedIndex;
    if (i == null) return null;
    return _accentOf(widget.palettes[i].components ?? const []);
  }

  @override
  Widget build(BuildContext context) {
    final safePad = MediaQuery.paddingOf(context);
    return Positioned(
      top: safePad.top + 16,
      right: safePad.right + 12,
      child: AnimatedBuilder(
        animation: _fade,
        // Never dim while open, regardless of where the fade controller is.
        builder: (context, child) =>
            Opacity(opacity: _open ? 1.0 : _fade.value, child: child),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _TriggerButton(
              open: _open,
              accent: _selectedAccent(),
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
                  mode: widget.mode,
                  onSelected: _select,
                  onModeSelected: _selectMode,
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

  /// Accent of the current selection, or null for "All".
  final Color? accent;
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
                    child: _AccentDot(accent: accent),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Small status dot on the trigger: the current accent, or a rainbow sweep for
/// "All" (random rotation).
class _AccentDot extends StatelessWidget {
  const _AccentDot({required this.accent, this.size = 10});

  final Color? accent;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: accent,
        gradient: accent == null
            ? const SweepGradient(
                colors: [
                  Color(0xffFF4D4D),
                  Color(0xffFFD24D),
                  Color(0xff4DFF88),
                  Color(0xff4DD2FF),
                  Color(0xff8B4DFF),
                  Color(0xffFF4DD2),
                  Color(0xffFF4D4D),
                ],
              )
            : null,
        border: Border.all(color: Colors.white, width: 1.2),
        boxShadow: accent != null
            ? [BoxShadow(color: accent!.withValues(alpha: 0.8), blurRadius: 6)]
            : null,
      ),
    );
  }
}

class _DrawerPanel extends StatefulWidget {
  const _DrawerPanel({
    required this.palettes,
    required this.selectedIndex,
    required this.mode,
    required this.onSelected,
    required this.onModeSelected,
  });

  final List<Palette> palettes;
  final int? selectedIndex;
  final PaletteMode mode;
  final ValueChanged<int> onSelected;
  final ValueChanged<PaletteMode> onModeSelected;

  @override
  State<_DrawerPanel> createState() => _DrawerPanelState();
}

class _DrawerPanelState extends State<_DrawerPanel> {
  static const _itemExtent = 56.0;
  static const _listPadding = 8.0;
  static final _modeCount = PaletteMode.values.length;

  final _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    // Once laid out, center the active tile so the drawer opens already
    // scrolled to the current selection.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_controller.hasClients) return;
      // List layout: 3 mode rows, then palette i at row 3 + i.
      final pos = widget.selectedIndex != null
          ? _modeCount + widget.selectedIndex!
          : widget.mode.index;
      final itemCenter = _listPadding + pos * _itemExtent + _itemExtent / 2;
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
    // A trackpad two-finger scroll over the list must scroll it, not exit the
    // showcase. Veto the host's swipe-to-exit for this gesture.
    return Listener(
      onPointerPanZoomStart: (_) =>
          const ShowcasePopVetoNotification().dispatch(context),
      child: _panel(context),
    );
  }

  Widget _panel(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          width: 252,
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
              Container(height: 1, color: Colors.white.withValues(alpha: 0.10)),
              Flexible(
                child: ListView(
                  controller: _controller,
                  itemExtent: _itemExtent,
                  padding: const EdgeInsets.symmetric(vertical: _listPadding),
                  children: [
                    for (final m in PaletteMode.values)
                      _ModeTile(
                        mode: m,
                        selected:
                            widget.selectedIndex == null && widget.mode == m,
                        onTap: () => widget.onModeSelected(m),
                      ),
                    for (var i = 0; i < widget.palettes.length; i++)
                      _PaletteTile(
                        index: i,
                        swatch: widget.palettes[i].components,
                        selected: widget.selectedIndex == i,
                        onTap: () => widget.onSelected(i),
                      ),
                  ],
                ),
              ),
            ],
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

class _ModeTile extends StatelessWidget {
  const _ModeTile({
    required this.mode,
    required this.selected,
    required this.onTap,
  });

  final PaletteMode mode;
  final bool selected;
  final VoidCallback onTap;

  String get _label => switch (mode) {
    PaletteMode.all => 'All palettes',
    PaletteMode.dark => 'Dark only',
    PaletteMode.light => 'Light only',
  };

  Widget get _leading {
    final child = switch (mode) {
      PaletteMode.all => const _AccentDot(accent: null, size: 15),
      PaletteMode.dark => const Icon(
        Icons.dark_mode_rounded,
        color: Colors.white,
        size: 18,
      ),
      PaletteMode.light => const Icon(
        Icons.light_mode_rounded,
        color: Colors.white,
        size: 18,
      ),
    };
    return SizedBox(width: 18, height: 18, child: Center(child: child));
  }

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
                color: selected ? Colors.white : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: Row(
            children: [
              _leading,
              const SizedBox(width: 10),
              Text(
                _label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              if (selected)
                const Icon(Icons.check_rounded, color: Colors.white, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}

class _PaletteTile extends StatelessWidget {
  const _PaletteTile({
    required this.index,
    required this.swatch,
    required this.selected,
    required this.onTap,
  });

  final int index;
  final List<Color>? swatch;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = swatch ?? const <Color>[];
    final accent = _accentOf(colors);
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
              Expanded(child: _label(colors)),
              if (selected) Icon(Icons.check_rounded, color: accent, size: 18),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(List<Color> colors) {
    return Row(
      children: [
        // A real, static frame of the clock rendered in this palette.
        _ClockPreview(index: index, colors: colors),
        const SizedBox(width: 10),
        // Contiguous color strip: squares butted together, no gaps.
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final color in colors)
                Container(width: 18, height: 26, color: color),
            ],
          ),
        ),
      ],
    );
  }
}

/// A real, static frame of the particle clock rendered in a given palette.
///
/// It instantiates the actual clock effects, ticks them a fixed number of
/// times to populate a representative frame, then bakes that frame into a
/// cached image — so each palette is simulated only once.
class _ClockPreview extends StatefulWidget {
  const _ClockPreview({required this.index, required this.colors});

  final int index;
  final List<Color> colors;

  @override
  State<_ClockPreview> createState() => _ClockPreviewState();
}

class _ClockPreviewState extends State<_ClockPreview> {
  // Rendered large so particle sizes (which scale with the canvas) read
  // properly, then downscaled into the thumbnail.
  static const _renderSize = Size(480, 300);
  static final Map<int, ui.Image> _cache = {};

  ui.Image? _image;

  @override
  void initState() {
    super.initState();
    if (widget.colors.isNotEmpty) {
      _image = _cache[widget.index] ??= _render();
    }
  }

  ui.Image _render() {
    // Order the palette the same way the live clock does: first color is the
    // background, the rest are sorted so the last is the accent.
    final ordered = Rnd.orderPalette(List<Color>.from(widget.colors));
    final time = DateTime.now();

    final bgFx = BgFx(size: _renderSize, time: time)..setPalette(ordered);
    final fx = ParticleClockFx(
      size: _renderSize,
      time: time,
      numParticles: 1400,
    )..setPalette(ordered);

    // Advance the simulation to a settled, representative frame.
    for (var i = 0; i < 4; i++) {
      bgFx.tick(Duration(milliseconds: i * 16));
    }
    for (var i = 0; i < 130; i++) {
      fx.tick(Duration(milliseconds: i * 16));
    }

    final rect = Rect.fromLTWH(0, 0, _renderSize.width, _renderSize.height);
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder, rect);
    final accent = ordered.components!.last;

    // Same layering as the live Scene: bg fill, blurred bg particles, face,
    // seconds, foreground particles.
    canvas.drawPaint(Paint()..color = ordered.components!.first);
    canvas.saveLayer(
      rect,
      Paint()
        ..imageFilter = ui.ImageFilter.blur(
          sigmaX: _renderSize.width * .05,
          sigmaY: 0,
        ),
    );
    ClockBgParticlePainter(fx: bgFx).paint(canvas, _renderSize);
    canvas.restore();
    ClockFacePainter(accentColor: accent).paint(canvas, _renderSize);
    ClockSecondsPainter(accentColor: accent).paint(canvas, _renderSize);
    ClockFxPainter(fx: fx).paint(canvas, _renderSize);

    return recorder.endRecording().toImageSync(
      _renderSize.width.toInt(),
      _renderSize.height.toInt(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 68,
      height: 42,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
      ),
      child: _image == null
          ? null
          : RawImage(
              image: _image,
              fit: BoxFit.cover,
              filterQuality: FilterQuality.medium,
            ),
    );
  }
}
