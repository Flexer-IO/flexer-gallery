import 'package:flutter/material.dart';
import 'deps/font_awesome_flutter/font_awesome_flutter.dart';

class MusicTopTabs extends StatefulWidget {
  final int colorVal;
  const MusicTopTabs(this.colorVal, {Key? key}) : super(key: key);

  @override
  _MusicTopTabsState createState() => _MusicTopTabsState();
}

class _MusicTopTabsState extends State<MusicTopTabs>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late int _colorVal;

  @override
  void initState() {
    super.initState();
    _colorVal = widget.colorVal;
    _tabController = TabController(vsync: this, length: 6);
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    setState(() {
      _colorVal = 0xff2196f3;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            isScrollable: true,
            indicatorWeight: 4.0,
            indicatorColor: const Color(0xff2196f3),
            unselectedLabelColor: Colors.grey,
            controller: _tabController,
            tabs: <Widget>[
              Tab(
                icon: Icon(
                  FontAwesomeIcons.compass as IconData?,
                  color: _tabController.index == 0
                      ? Color(_colorVal)
                      : Colors.grey,
                ),
                child: Text(
                  'For you',
                  style: TextStyle(
                    color: _tabController.index == 0
                        ? Color(_colorVal)
                        : Colors.grey,
                  ),
                ),
              ),
              Tab(
                icon: Icon(
                  FontAwesomeIcons.music as IconData?,
                  color: _tabController.index == 1
                      ? Color(_colorVal)
                      : Colors.grey,
                ),
                child: Text(
                  'Top Songs',
                  style: TextStyle(
                    color: _tabController.index == 1
                        ? Color(_colorVal)
                        : Colors.grey,
                  ),
                ),
              ),
              Tab(
                icon: Icon(
                  FontAwesomeIcons.dotCircle as IconData?,
                  color: _tabController.index == 2
                      ? Color(_colorVal)
                      : Colors.grey,
                ),
                child: Text(
                  'Top Album',
                  style: TextStyle(
                    color: _tabController.index == 2
                        ? Color(_colorVal)
                        : Colors.grey,
                  ),
                ),
              ),
              Tab(
                icon: Icon(
                  FontAwesomeIcons.solidBookmark as IconData?,
                  color: _tabController.index == 3
                      ? Color(_colorVal)
                      : Colors.grey,
                ),
                child: Text(
                  'New Releases',
                  style: TextStyle(
                    color: _tabController.index == 3
                        ? Color(_colorVal)
                        : Colors.grey,
                  ),
                ),
              ),
              Tab(
                icon: Icon(
                  FontAwesomeIcons.shapes as IconData?,
                  color: _tabController.index == 4
                      ? Color(_colorVal)
                      : Colors.grey,
                ),
                child: Text(
                  'Genres',
                  style: TextStyle(
                    color: _tabController.index == 4
                        ? Color(_colorVal)
                        : Colors.grey,
                  ),
                ),
              ),
              Tab(
                icon: Icon(
                  FontAwesomeIcons.cartPlus as IconData?,
                  color: _tabController.index == 5
                      ? Color(_colorVal)
                      : Colors.grey,
                ),
                child: Text(
                  'Pre- orders',
                  style: TextStyle(
                    color: _tabController.index == 5
                        ? Color(_colorVal)
                        : Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}