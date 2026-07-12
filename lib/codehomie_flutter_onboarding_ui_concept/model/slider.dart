/// Model definitions for the onboarding slider.
///
/// This file defines the constants and data structures used to represent
/// each slide in the onboarding flow. It is fully null‑safe and compatible
/// with Dart 3.

/// Fallback constants definition to resolve missing import.
class Constants {
  static const String SLIDER_HEADING_1 = 'Slider Heading 1';
  static const String SLIDER_HEADING_2 = 'Slider Heading 2';
  static const String SLIDER_HEADING_3 = 'Slider Heading 3';
  static const String SLIDER_DESC = 'Slider description text.';
}

class Slider {
  final String sliderImageUrl;
  final String sliderHeading;
  final String sliderSubHeading;

  const Slider({
    required this.sliderImageUrl,
    required this.sliderHeading,
    required this.sliderSubHeading,
  });
}

final List<Slider> sliderArrayList = [
  Slider(
    sliderImageUrl: 'assets/images/slider_1.png',
    sliderHeading: Constants.SLIDER_HEADING_1,
    sliderSubHeading: Constants.SLIDER_DESC,
  ),
  Slider(
    sliderImageUrl: 'assets/images/slider_2.png',
    sliderHeading: Constants.SLIDER_HEADING_2,
    sliderSubHeading: Constants.SLIDER_DESC,
  ),
  Slider(
    sliderImageUrl: 'assets/images/slider_3.png',
    sliderHeading: Constants.SLIDER_HEADING_3,
    sliderSubHeading: Constants.SLIDER_DESC,
  ),
];