import 'dart:async';
import 'data.dart';
import 'dummyCard.dart';
import 'activeCard.dart';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

class CardDemo extends StatefulWidget {
  @override
  CardDemoState createState() => CardDemoState();
}

class CardDemoState extends State<CardDemo> with TickerProviderStateMixin {
  late final AnimationController _buttonController;
  late final Animation<double> rotate;
  late final Animation<double> right;
  late final Animation<double> bottom;
  late final Animation<double> width;
  int flag = 0;

  late final List<DecorationImage> data;
  List<DecorationImage> selectedData = [];

  @override
  void initState() {
    super.initState();

    // Convert the raw image path strings from `imageData` into DecorationImage objects.
    data = imageData
        .map<DecorationImage>((String path) =>
            DecorationImage(image: AssetImage(path), fit: BoxFit.cover))
        .toList();

    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    rotate = Tween<double>(
      begin: -0.0,
      end: -40.0,
    ).animate(
      CurvedAnimation(
        parent: _buttonController,
        curve: Curves.ease,
      ),
    );
    rotate.addListener(() {
      setState(() {
        if (rotate.isCompleted) {
          var i = data.removeLast();
          data.insert(0, i);
          _buttonController.reset();
        }
      });
    });

    right = Tween<double>(
      begin: 0.0,
      end: 400.0,
    ).animate(
      CurvedAnimation(
        parent: _buttonController,
        curve: Curves.ease,
      ),
    );
    bottom = Tween<double>(
      begin: 15.0,
      end: 100.0,
    ).animate(
      CurvedAnimation(
        parent: _buttonController,
        curve: Curves.ease,
      ),
    );
    width = Tween<double>(
      begin: 20.0,
      end: 25.0,
    ).animate(
      CurvedAnimation(
        parent: _buttonController,
        curve: Curves.bounceOut,
      ),
    );
  }

  @override
  void dispose() {
    _buttonController.dispose();
    super.dispose();
  }

  Future<void> _swipeAnimation() async {
    try {
      await _buttonController.forward();
    } on TickerCanceled {}
  }

  void dismissImg(DecorationImage img) {
    setState(() {
      data.remove(img);
    });
  }

  void addImg(DecorationImage img) {
    setState(() {
      data.remove(img);
      selectedData.add(img);
    });
  }

  void swipeRight() {
    if (flag == 0) {
      setState(() {
        flag = 1;
      });
    }
    _swipeAnimation();
  }

  void swipeLeft() {
    if (flag == 1) {
      setState(() {
        flag = 0;
      });
    }
    _swipeAnimation();
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 0.4;

    const double initialBottom = 15.0;
    final int dataLength = data.length;
    double backCardPosition = initialBottom + (dataLength - 1) * 10 + 10;
    double backCardWidth = -10.0;

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: const Color.fromRGBO(106, 94, 175, 1.0),
        centerTitle: true,
        leading: Container(
          margin: const EdgeInsets.all(15.0),
          child: const Icon(
            Icons.equalizer,
            color: Colors.cyan,
            size: 30.0,
          ),
        ),
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => PageMain()));
            },
            child: Container(
              margin: const EdgeInsets.all(15.0),
              child: const Icon(
                Icons.search,
                color: Colors.cyan,
                size: 30.0,
              ),
            ),
          ),
        ],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              "EVENTS",
              style: TextStyle(
                fontSize: 12.0,
                letterSpacing: 3.5,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              width: 15.0,
              height: 15.0,
              margin: const EdgeInsets.only(bottom: 20.0),
              alignment: Alignment.center,
              child: Text(
                dataLength.toString(),
                style: const TextStyle(fontSize: 10.0),
              ),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
      body: Container(
        color: const Color.fromRGBO(106, 94, 175, 1.0),
        alignment: Alignment.center,
        child: dataLength > 0
            ? Stack(
                alignment: AlignmentDirectional.center,
                children: data.map<Widget>((item) {
                  if (data.indexOf(item) == dataLength - 1) {
                    return cardDemo(
                      item,
                      bottom.value,
                      right.value,
                      0.0,
                      backCardWidth + 10,
                      rotate.value,
                      rotate.value < -10 ? 0.1 : 0.0,
                      context,
                      () => dismissImg(item),
                      flag,
                      () => addImg(item),
                      swipeRight,
                      swipeLeft,
                    );
                  } else {
                    backCardPosition = backCardPosition - 10;
                    backCardWidth = backCardWidth + 10;

                    return cardDemoDummy(
                      item,
                      backCardPosition,
                      0.0,
                      0.0,
                      backCardWidth,
                      0.0,
                      0.0,
                      context,
                    );
                  }
                }).toList(),
              )
            : const Text(
                "No Event Left",
                style: TextStyle(color: Colors.white, fontSize: 50.0),
              ),
      ),
    );
  }
}