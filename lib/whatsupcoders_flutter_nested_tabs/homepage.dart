import 'package:flutter/material.dart';
import 'deps/font_awesome_flutter/font_awesome_flutter.dart';
import 'hometoptabs.dart';
import 'gamestoptabs.dart';
import 'moviestoptabs.dart';
import 'bookstoptabs.dart';
import 'musictoptabs.dart';

class HomePage extends StatefulWidget {
  final Widget child;
  const HomePage({Key? key, required this.child}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

Color PrimaryColor = const Color(0xff109618);

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          // backgroundColor: Color(0xff109618),
          backgroundColor: PrimaryColor,
          title: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: _GooglePlayAppBar(),
          ),
          bottom: TabBar(
            isScrollable: true,
            indicatorColor: Colors.white,
            indicatorWeight: 6.0,
            onTap: (index) {
              setState(() {
                switch (index) {
                  case 0:
                    PrimaryColor = const Color(0xffff5722);
                    break;
                  case 1:
                    PrimaryColor = const Color(0xff3f51b5);
                    break;
                  case 2:
                    PrimaryColor = const Color(0xffe91e63);
                    break;
                  case 3:
                    PrimaryColor = const Color(0xff9c27b0);
                    break;
                  case 4:
                    PrimaryColor = const Color(0xff2196f3);
                    break;
                  default:
                }
              });
            },
            tabs: <Widget>[
              Tab(
                child: Container(
                  child: const Text(
                    'HOME',
                    style: TextStyle(color: Colors.white, fontSize: 18.0),
                  ),
                ),
              ),
              Tab(
                child: Container(
                  child: const Text(
                    'GAMES',
                    style: TextStyle(color: Colors.white, fontSize: 18.0),
                  ),
                ),
              ),
              Tab(
                child: Container(
                  child: const Text(
                    'MOVIES',
                    style: TextStyle(color: Colors.white, fontSize: 18.0),
                  ),
                ),
              ),
              Tab(
                child: Container(
                  child: const Text(
                    'BOOK',
                    style: TextStyle(color: Colors.white, fontSize: 18.0),
                  ),
                ),
              ),
              Tab(
                child: Container(
                  child: const Text(
                    'MUSIC',
                    style: TextStyle(color: Colors.white, fontSize: 18.0),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            HomeTopTabs(0xffff5722), //ff5722
            GamesTopTabs(0xff3f51b5), //3f51b5
            MoviesTopTabs(0xffe91e63), //e91e63
            BooksTopTabs(0xff9c27b0), //9c27b0
            MusicTopTabs(0xff2196f3), //2196f3 //4CAF50
          ],
        ),
      ),
    );
  }
}

Widget _GooglePlayAppBar() {
  return Container(
    color: Colors.white,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          child: IconButton(
            icon: Icon(
              FontAwesomeIcons.bars as IconData?,
            ),
            onPressed: () {},
          ),
        ),
        Container(
          child: const Text(
            'Google Play',
            style: TextStyle(color: Colors.grey),
          ),
        ),
        Container(
          child: IconButton(
            icon: Icon(
              FontAwesomeIcons.microphone as IconData?,
              color: Colors.blueGrey,
            ),
            onPressed: () {},
          ),
        ),
      ],
    ),
  );
}