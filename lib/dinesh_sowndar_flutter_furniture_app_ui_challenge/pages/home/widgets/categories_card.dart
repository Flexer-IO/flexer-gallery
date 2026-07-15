import 'package:flutter/material.dart';
import 'data.dart';
import 'pages/details/details_page.dart';
import 'widgets/category_widget.dart';
import 'deps/google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class CategoriesCard extends StatelessWidget {
  CategoriesCard({super.key});
  GlobalKey catListKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 310,
      child: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          Hero(
            tag: 'blue_card',
            child: Material(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 270,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(15.0),
                  ),
                  color: Theme.of(context).primaryColor,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Image.asset(
                                  "packages/showcase_library/assets/dinesh_sowndar_flutter_furniture_app_ui_challenge/images/weather.png",
                                  width: 25,
                                ),
                                 Text(
                                  " 32'C",
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                             Text(
                              "24",
                              style: GoogleFonts.poppins(
                                  height: 1.1,
                                  fontSize: 50,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            ),
                             Text(
                              "January",
                              style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  height: 0.2,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 25,
            right: 0,
            left: 0,
            child: Hero(
              tag: "cat",
              child: Material(
                color: Colors.transparent,
                child: SizedBox(
                  key: catListKey,
                  height: 85,
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                    itemCount: categories.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          final _offset = (catListKey.currentContext!
                                  .findRenderObject() as RenderBox)
                              .localToGlobal(Offset.zero);
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation1, animation2) =>
                                  DetailsPage(
                                      selectedCat: index,
                                      catListOffset: _offset),
                              transitionDuration:
                                  const Duration(milliseconds: 150),
                              transitionsBuilder: (_, a, __, c) =>
                                  FadeTransition(opacity: a, child: c),
                            ),
                          );
                        },
                        child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: CategoryWidget(
                              category: categories[index],
                            )),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          Positioned(
              top: 0,
              right: 10,
              child: Image.asset(
                "packages/showcase_library/assets/dinesh_sowndar_flutter_furniture_app_ui_challenge/images/ladder.png",
                height: 180,
              ))
        ],
      ),
    );
  }
}
