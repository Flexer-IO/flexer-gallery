import 'multicity_input.dart';
import 'price_tab/price_tab.dart';
import 'package:flutter/material.dart';

class ContentCard extends StatefulWidget {
  @override
  _ContentCardState createState() => _ContentCardState();
}

class _ContentCardState extends State<ContentCard> {
  bool showInput = true;
  bool showInputTabOptions = true;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (!showInput) {
          setState(() {
            showInput = true;
            showInputTabOptions = true;
          });
          return Future(() => false);
        } else {
          return Future(() => true);
        }
      },
      child: Card(
        elevation: 4.0,
        margin: const EdgeInsets.all(8.0),
        child: DefaultTabController(
          length: 3,
          child: LayoutBuilder(
            builder:
                (BuildContext context, BoxConstraints viewportConstraints) {
              return Column(
                children: <Widget>[
                  _buildTabBar(),
                  _buildContentContainer(viewportConstraints),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Stack(
      children: <Widget>[
        Positioned.fill(
          top: null,
          child: Container(
            height: 2.0,
            color: const Color(0xFFEEEEEE),
          ),
        ),
        TabBar(
          tabs: [
            Tab(text: showInputTabOptions ? "Flight" : "Price"),
            Tab(text: showInputTabOptions ? "Train" : "Duration"),
            Tab(text: showInputTabOptions ? "Bus" : "Stops"),
          ],
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
        ),
      ],
    );
  }

  Widget _buildContentContainer(BoxConstraints viewportConstraints) {
    return Expanded(
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: viewportConstraints.maxHeight - 48.0,
          ),
          child: IntrinsicHeight(
            child: showInput
                ? _buildMulticityTab()
                : PriceTab(
                    height: viewportConstraints.maxHeight - 48.0,
                    onPlaneFlightStart: () =>
                        setState(() => showInputTabOptions = false),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildMulticityTab() {
    return Column(
      children: <Widget>[
        MulticityInput(),
        Expanded(child: Container()),
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0, top: 8.0),
          child: FloatingActionButton(
            onPressed: () => setState(() => showInput = false),
            child: const Icon(Icons.timeline, size: 36.0),
          ),
        ),
      ],
    );
  }
}