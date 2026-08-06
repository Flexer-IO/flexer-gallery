import 'package:flutter/material.dart';

class HomeTopChartsTabs extends StatefulWidget {
  final Widget? child;

  HomeTopChartsTabs({Key? key, this.child}) : super(key: key);

  @override
  _HomeTopChartsTabsState createState() => _HomeTopChartsTabsState();
}

class _HomeTopChartsTabsState extends State<HomeTopChartsTabs> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          const SizedBox(
            height: 10.0,
          ),
          ImageContainer(),
        ],
      ),
    );
  }

  Widget ImageContainer() {
    return Container(
      height: 200.0,
      child: const Center(child: Text('TopCharts')),
    );
  }
}