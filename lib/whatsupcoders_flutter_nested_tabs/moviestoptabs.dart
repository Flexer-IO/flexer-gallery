import 'package:flutter/material.dart';
import 'deps/font_awesome_flutter/font_awesome_flutter.dart';
import 'moviereleasetabs.dart';

class MoviesTopTabs extends StatefulWidget {
  final int colorVal;
  const MoviesTopTabs(this.colorVal, {Key? key}) : super(key: key);
  @override
  _MoviesTopTabsState createState() => _MoviesTopTabsState();
}

class _MoviesTopTabsState extends State<MoviesTopTabs>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late int _colorVal;

  @override
  void initState() {
    super.initState();
    _colorVal = widget.colorVal;
    _tabController = TabController(vsync: this, length: 7);
    _tabController.addListener(_handleTabSelection);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabSelection() {
    setState(() {
      _colorVal = 0xffe91e63;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 7,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            isScrollable: true,
            indicatorWeight: 4.0,
            indicatorColor: Color(0xffe91e63),
            unselectedLabelColor: Colors.grey,
            controller: _tabController,
            tabs: <Widget>[
              Tab(
                icon: Icon(FontAwesomeIcons.compass as IconData,
                    color: _tabController.index == 0
                        ? Color(_colorVal)
                        : Colors.grey),
                child: Text('For You',
                    style: TextStyle(
                        color: _tabController.index == 0
                            ? Color(_colorVal)
                            : Colors.grey)),
              ),
              Tab(
                icon: Icon(FontAwesomeIcons.tv as IconData,
                    color: _tabController.index == 1
                        ? Color(_colorVal)
                        : Colors.grey),
                child: Text('TV',
                    style: TextStyle(
                        color: _tabController.index == 1
                            ? Color(_colorVal)
                            : Colors.grey)),
              ),
              Tab(
                icon: Icon(FontAwesomeIcons.solidStar as IconData,
                    color: _tabController.index == 2
                        ? Color(_colorVal)
                        : Colors.grey),
                child: Text('TopSelling',
                    style: TextStyle(
                        color: _tabController.index == 2
                            ? Color(_colorVal)
                            : Colors.grey)),
              ),
              Tab(
                icon: Icon(FontAwesomeIcons.solidBookmark as IconData,
                    color: _tabController.index == 3
                        ? Color(_colorVal)
                        : Colors.grey),
                child: Text('New Releases',
                    style: TextStyle(
                        color: _tabController.index == 3
                            ? Color(_colorVal)
                            : Colors.grey)),
              ),
              Tab(
                icon: Icon(FontAwesomeIcons.shapes as IconData,
                    color: _tabController.index == 4
                        ? Color(_colorVal)
                        : Colors.grey),
                child: Text('Genres',
                    style: TextStyle(
                        color: _tabController.index == 4
                            ? Color(_colorVal)
                            : Colors.grey)),
              ),
              Tab(
                icon: Icon(FontAwesomeIcons.film as IconData,
                    color: _tabController.index == 5
                        ? Color(_colorVal)
                        : Colors.grey),
                child: Text('Studio',
                    style: TextStyle(
                        color: _tabController.index == 5
                            ? Color(_colorVal)
                            : Colors.grey)),
              ),
              Tab(
                icon: Icon(FontAwesomeIcons.home as IconData,
                    color: _tabController.index == 6
                        ? Color(_colorVal)
                        : Colors.grey),
                child: Text('Family',
                    style: TextStyle(
                        color: _tabController.index == 6
                            ? Color(_colorVal)
                            : Colors.grey)),
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: <Widget>[
            Container(
              height: 200.0,
              child: Center(child: Text('For you')),
            ),
            Container(
              height: 200.0,
              child: Center(child: Text('TV')),
            ),
            Container(
              height: 200.0,
              child: Center(child: Text('Top Sellings')),
            ),
            MovieReleaseTabs(),
            Container(
              height: 200.0,
              child: Center(child: Text('Genres')),
            ),
            Container(
              height: 200.0,
              child: Center(child: Text('Studio')),
            ),
            Container(
              height: 200.0,
              child: Center(child: Text('Family')),
            ),
          ],
        ),
      ),
    );
  }
}