import 'package:flutter/material.dart';
import 'deps/font_awesome_flutter/font_awesome_flutter.dart';
import 'gametopchartstabs.dart';

class GamesTopTabs extends StatefulWidget {
  final int colorVal;
  const GamesTopTabs(this.colorVal, {Key? key}) : super(key: key);

  @override
  _GamesTopTabsState createState() => _GamesTopTabsState();
}

class _GamesTopTabsState extends State<GamesTopTabs>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late int _colorVal;

  @override
  void initState() {
    super.initState();
    _colorVal = widget.colorVal;
    _tabController = TabController(vsync: this, length: 8);
    _tabController.addListener(_handleTabSelection);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabSelection() {
    setState(() {
      _colorVal = 0xff3f51b5;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 8,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            isScrollable: true,
            indicatorWeight: 4.0,
            indicatorColor: const Color(0xff3f51b5),
            unselectedLabelColor: Colors.grey,
            controller: _tabController,
            tabs: <Widget>[
              Tab(
                icon: Icon(
                  FontAwesomeIcons.compass as IconData,
                  color: _tabController.index == 0
                      ? Color(_colorVal)
                      : Colors.grey,
                ),
                child: Text(
                  'For You',
                  style: TextStyle(
                    color: _tabController.index == 0
                        ? Color(_colorVal)
                        : Colors.grey,
                  ),
                ),
              ),
              Tab(
                icon: Icon(
                  FontAwesomeIcons.chartBar as IconData,
                  color: _tabController.index == 1
                      ? Color(_colorVal)
                      : Colors.grey,
                ),
                child: Text(
                  'Top Charts',
                  style: TextStyle(
                    color: _tabController.index == 1
                        ? Color(_colorVal)
                        : Colors.grey,
                  ),
                ),
              ),
              Tab(
                icon: Icon(
                  FontAwesomeIcons.plusSquare as IconData,
                  color: _tabController.index == 2
                      ? Color(_colorVal)
                      : Colors.grey,
                ),
                child: Text(
                  'New',
                  style: TextStyle(
                    color: _tabController.index == 2
                        ? Color(_colorVal)
                        : Colors.grey,
                  ),
                ),
              ),
              Tab(
                icon: Icon(
                  FontAwesomeIcons.calendarDay as IconData,
                  color: _tabController.index == 3
                      ? Color(_colorVal)
                      : Colors.grey,
                ),
                child: Text(
                  'Events',
                  style: TextStyle(
                    color: _tabController.index == 3
                        ? Color(_colorVal)
                        : Colors.grey,
                  ),
                ),
              ),
              Tab(
                icon: Icon(
                  FontAwesomeIcons.solidGem as IconData,
                  color: _tabController.index == 4
                      ? Color(_colorVal)
                      : Colors.grey,
                ),
                child: Text(
                  'Premium',
                  style: TextStyle(
                    color: _tabController.index == 4
                        ? Color(_colorVal)
                        : Colors.grey,
                  ),
                ),
              ),
              Tab(
                icon: Icon(
                  FontAwesomeIcons.shapes as IconData,
                  color: _tabController.index == 5
                      ? Color(_colorVal)
                      : Colors.grey,
                ),
                child: Text(
                  'Category',
                  style: TextStyle(
                    color: _tabController.index == 5
                        ? Color(_colorVal)
                        : Colors.grey,
                  ),
                ),
              ),
              Tab(
                icon: Icon(
                  FontAwesomeIcons.solidBookmark as IconData,
                  color: _tabController.index == 6
                      ? Color(_colorVal)
                      : Colors.grey,
                ),
                child: Text(
                  'Editors choice',
                  style: TextStyle(
                    color: _tabController.index == 6
                        ? Color(_colorVal)
                        : Colors.grey,
                  ),
                ),
              ),
              Tab(
                icon: Icon(
                  FontAwesomeIcons.solidStar as IconData,
                  color: _tabController.index == 7
                      ? Color(_colorVal)
                      : Colors.grey,
                ),
                child: Text(
                  'Family',
                  style: TextStyle(
                    color: _tabController.index == 7
                        ? Color(_colorVal)
                        : Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: <Widget>[
            Column(
              children: <Widget>[
                const Center(
                  child: Text("For you Tabs"),
                ),
              ],
            ),
            GameTopChartsTabs(0xff3f51b5),
            Container(
              height: 200.0,
              child: const Center(child: Text('New')),
            ),
            Container(
              height: 200.0,
              child: const Center(child: Text('Premium')),
            ),
            Container(
              height: 200.0,
              child: const Center(child: Text('Category')),
            ),
            Container(
              height: 200.0,
              child: const Center(child: Text('Events')),
            ),
            Container(
              height: 200.0,
              child: const Center(child: Text('Editor Choice')),
            ),
            Container(
              height: 200.0,
              child: const Center(child: Text('Family')),
            ),
          ],
        ),
      ),
    );
  }
}