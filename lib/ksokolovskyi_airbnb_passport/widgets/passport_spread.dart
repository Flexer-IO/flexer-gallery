import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Minimal model representing a host.
class Host {
  const Host({
    required this.id,
    required this.name,
    required this.avatarPath,
    required this.rating,
    required this.isSuperhost,
    this.stats,
  });

  final String id;
  final String name;
  final String avatarPath;
  final double rating;
  final bool isSuperhost;
  final HostStats? stats;
}

/// Statistics associated with a host.
class HostStats {
  const HostStats({
    required this.reviewsCount,
    required this.yearsHosting,
  });

  final int reviewsCount;
  final int yearsHosting;
}

/// Demo colour palette used in the UI.
class DemoColors {
  static const Color white = Colors.white;
}

/// Demo formatters used in the UI.
class DemoFormatters {
  static final NumberFormat ratingFormatter = NumberFormat('#0.0');
}

/// Simple star icon widget used for rating display.
class StarIcon extends StatelessWidget {
  const StarIcon({required this.size, super.key});

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.star,
      size: size.width,
      color: Colors.amber,
    );
  }
}

/// Custom rect tween for the back page hero animation.
class BackPageRectTween extends RectTween {
  BackPageRectTween({required Rect begin, required Rect end})
      : super(begin: begin, end: end);
}

/// Custom rect tween for the front page hero animation.
class FrontPageRectTween extends RectTween {
  FrontPageRectTween({
    required Rect begin,
    required Rect end,
    required this.flightDirection,
  }) : super(begin: begin, end: end);

  final HeroFlightDirection flightDirection;
}

class PassportSpread extends StatelessWidget {
  const PassportSpread({
    required this.host,
    super.key,
  });

  final Host host;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final stats = host.stats;

    return RepaintBoundary(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 245),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final size = constraints.biggest;

            final open = Container(
              decoration: BoxDecoration(
                color: DemoColors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 32,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            foregroundImage: AssetImage(host.avatarPath),
                            maxRadius: 40,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            host.name,
                            style: textTheme.headlineLarge,
                          ),
                          Text(
                            host.isSuperhost ? 'Superhost' : 'Host',
                            style: textTheme.labelMedium,
                          ),
                        ],
                      ),
                    ),
                    if (stats != null)
                      SizedBox(
                        width: size.width / 4,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${stats.reviewsCount}',
                              style: textTheme.headlineMedium,
                            ),
                            Text(
                              'Reviews',
                              style: textTheme.labelSmall,
                            ),
                            const SizedBox(height: 4),
                            const Divider(),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  DemoFormatters.ratingFormatter.format(
                                    host.rating,
                                  ),
                                  style: textTheme.headlineMedium,
                                ),
                                const SizedBox(width: 2),
                                const StarIcon(
                                  size: Size.square(14),
                                ),
                              ],
                            ),
                            Text(
                              'Rating',
                              style: textTheme.labelSmall,
                            ),
                            const SizedBox(height: 4),
                            const Divider(),
                            const SizedBox(height: 4),
                            Text(
                              '${stats.yearsHosting}',
                              style: textTheme.headlineMedium,
                            ),
                            Text(
                              'Years hosting',
                              style: textTheme.labelSmall,
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            );

            final right = SizedBox(
              width: size.width / 2,
              height: size.height,
              child: OverflowBox(
                minWidth: size.width / 2,
                maxWidth: size.width,
                alignment: Alignment.centerRight,
                child: ClipRect(
                  child: Align(
                    widthFactor: 0.5,
                    alignment: Alignment.centerRight,
                    child: open,
                  ),
                ),
              ),
            );

            final left = SizedBox(
              width: size.width / 2,
              height: size.height,
              child: OverflowBox(
                minWidth: size.width / 2,
                maxWidth: size.width,
                alignment: Alignment.centerLeft,
                child: ClipRect(
                  child: Align(
                    widthFactor: 0.5,
                    alignment: Alignment.centerLeft,
                    child: open,
                  ),
                ),
              ),
            );

            return Stack(
              children: [
                Positioned(
                  right: 0,
                  child: Hero(
                    tag: 'back_page_${host.id}',
                    child: right,
                    createRectTween: (begin, end) {
                      return BackPageRectTween(
                        begin: begin!,
                        end: end!,
                      );
                    },
                  ),
                ),
                Positioned(
                  left: 0,
                  child: Hero(
                    tag: 'front_page_${host.id}',
                    child: left,
                    createRectTween: (begin, end) {
                      return FrontPageRectTween(
                        begin: begin!,
                        end: end!,
                        flightDirection: HeroFlightDirection.push,
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}