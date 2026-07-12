import 'package:flutter/cupertino.dart';

// Placeholder definitions to satisfy missing imports.
// In the original project these would be provided by separate files.
class Constants {
  static const String POPPINS = 'Poppins';
  static const String OPEN_SANS = 'OpenSans';
}

class Slider {
  final String? sliderImageUrl;
  final String? sliderHeading;

  const Slider({this.sliderImageUrl, this.sliderHeading});
}

// Example placeholder list. The real implementation should provide actual data.
final List<Slider> sliderArrayList = <Slider>[];

class SlideItem extends StatelessWidget {
  final int index;
  const SlideItem(this.index, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.width * 0.6,
          width: MediaQuery.of(context).size.height * 0.4,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                sliderArrayList[index].sliderImageUrl ?? '',
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 60.0,
        ),
        Text(
          sliderArrayList[index].sliderHeading ?? '',
          style: const TextStyle(
            fontFamily: Constants.POPPINS,
            fontWeight: FontWeight.w700,
            fontSize: 20.5,
          ),
        ),
        const SizedBox(
          height: 15.0,
        ),
        const Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.0),
            child: Text(
              '',
              style: TextStyle(
                fontFamily: Constants.OPEN_SANS,
                fontWeight: FontWeight.w500,
                letterSpacing: 1.5,
                fontSize: 12.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}