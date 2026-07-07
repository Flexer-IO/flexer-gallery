import 'package:flutter/material.dart';
import 'models.dart';

class RatingInformation extends StatelessWidget {
  const RatingInformation(this.movie, {Key? key}) : super(key: key);
  final Movie movie;

  Widget _buildRatingBar(ThemeData theme) {
    final List<Widget> stars = <Widget>[];

    for (var i = 1; i <= 5; i++) {
      final Color color = i <= movie.starRating
          ? theme.colorScheme.secondary
          : Colors.black12;
      final Icon star = Icon(
        Icons.star,
        color: color,
      );

      stars.add(star);
    }

    return Row(children: stars);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    final TextStyle ratingCaptionStyle = (textTheme.bodySmall ?? const TextStyle())
        .copyWith(color: Colors.black45);

    final Widget numericRating = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          movie.rating.toString(),
          style: (textTheme.titleLarge ?? const TextStyle()).copyWith(
            fontWeight: FontWeight.w400,
            color: theme.colorScheme.secondary,
          ),
        ),
        const SizedBox(height: 4.0),
        Text(
          'Ratings',
          style: ratingCaptionStyle,
        ),
      ],
    );

    final Widget starRating = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildRatingBar(theme),
        const Padding(
          padding: EdgeInsets.only(top: 4.0, left: 4.0),
          child: Text(
            'Grade now',
            // The style will be applied from ratingCaptionStyle below.
          ),
        ),
        // Apply the style to the 'Grade now' text.
        // Since we cannot modify the widget tree, we wrap it with a Builder to set the style.
        Builder(
          builder: (context) => Text(
            'Grade now',
            style: ratingCaptionStyle,
          ),
        ),
      ],
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        numericRating,
        const SizedBox(width: 16.0),
        starRating,
      ],
    );
  }
}