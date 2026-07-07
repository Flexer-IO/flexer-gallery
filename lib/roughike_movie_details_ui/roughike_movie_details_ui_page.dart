import 'package:flutter/material.dart';
import 'movie_details_page.dart';
import 'movie_api.dart';

class RoughikeMovieDetailsUiPage extends StatelessWidget {
  const RoughikeMovieDetailsUiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MovieDetailsPage(testMovie);
  }
}