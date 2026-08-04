import 'package:flutter/material.dart';
import 'Custom_Icons.dart';
import 'data.dart';

void main() => runApp(const MaterialApp(
      home: MyApp(),
      debugShowCheckedModeBanner: false,
    ));

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentIndex = 0;

  Widget _buildGradientContainer(double width, double height) {
    return Align(
      alignment: Alignment.topRight,
      child: Container(
        width: width * .8,
        height: height / 2,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [Color(0xFFfbfcfd), Color(0xFFf2f3f8)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.5, 1.0])),
      ),
    );
  }

  Widget _buildAppBar() {
    return Positioned(
      top: 40.0,
      left: 20.0,
      right: 20.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            icon: const Icon(CustomIcons.menu, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(CustomIcons.search, color: Colors.black),
            onPressed: () {},
          )
        ],
      ),
    );
  }

  Widget _buildTitle(double height) {
    return Positioned(
      top: height * .2,
      left: 30.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text("Wooden Armchair",
              style: TextStyle(fontSize: 28.0, fontFamily: "Montserrat-Bold")),
          const Text("Lorem Ipsem",
              style: TextStyle(fontSize: 16.0, fontFamily: "Montserrat-Medium"))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf2f3f8),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double width = constraints.maxWidth;
          final double height = constraints.maxHeight;

          return Stack(
            fit: StackFit.expand,
            children: <Widget>[
              _buildGradientContainer(width, height),
              _buildAppBar(),
              _buildTitle(height),
              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  height: height * .6,
                  child: ListView.builder(
                    itemCount: images.length,
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 35.0, bottom: 60.0),
                        child: SizedBox(
                          width: 200.0,
                          child: Stack(
                            fit: StackFit.expand,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(top: 45.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: (index % 2 == 0)
                                          ? Colors.white
                                          : const Color(0xFF2a2d3f),
                                      boxShadow: const [
                                        BoxShadow(
                                            color: Colors.black12,
                                            offset: Offset(0.0, 10.0),
                                            blurRadius: 10.0)
                                      ],
                                      borderRadius:
                                          BorderRadius.circular(12.0)),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Image.asset(
                                    images[index],
                                    width: 172.5,
                                    height: 199.0,
                                  ),
                                  const SizedBox(
                                    height: 12.0,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(title[index],
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                fontFamily: "Montserrat-Bold",
                                                color: (index % 2 == 0)
                                                    ? const Color(0xFF2a2d3f)
                                                    : Colors.white)),
                                        const SizedBox(
                                          height: 8.0,
                                        ),
                                        const Text("NEW SELL",
                                            style: TextStyle(
                                                fontSize: 12.0,
                                                fontFamily: "Montserrat-Medium",
                                                color: Colors.black)),
                                        const SizedBox(
                                          height: 50.0,
                                        ),
                                        Text(price[index] + " \$",
                                            style: TextStyle(
                                                fontSize: 30.0,
                                                fontFamily: "Montserrat-Bold",
                                                color: (index % 2 == 0)
                                                    ? const Color(0xFF2a2d3f)
                                                    : Colors.white))
                                      ],
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              )
            ],
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.black,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.panorama_horizontal),
              label: ''),
          BottomNavigationBarItem(
              icon: Icon(Icons.bookmark_border),
              label: ''),
        ],
      ),
      floatingActionButton: Container(
        width: 65.0,
        height: 65.0,
        decoration: const BoxDecoration(
            color: Color(0xFFfa7b58),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                  color: Color(0xFFf78a6c),
                  offset: Offset(0.0, 10.0),
                  blurRadius: 10.0)
            ]),
        child: RawMaterialButton(
          shape: const CircleBorder(),
          child: const Icon(
            Icons.add,
            size: 35.0,
            color: Colors.white,
          ),
          onPressed: () {},
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}