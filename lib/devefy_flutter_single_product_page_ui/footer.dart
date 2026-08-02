import 'package:flutter/material.dart';
import 'gredients.dart';
import 'pages/specification.dart';
import 'pages/productDesc.dart';
import 'pages/userReviews.dart';

var favnprice = Padding(
  padding:
      const EdgeInsets.only(left: 20.0, right: 20.0, top: 25.0, bottom: 12.0),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.favorite,
              color: Colors.red,
            ),
          ),
          Text("Add to wishList")
        ],
      ),
      Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "\$",
              style: TextStyle(fontSize: 20.0),
            ),
          ),
          Text(
            "9999.00",
            style: TextStyle(fontSize: 35.0),
          )
        ],
      )
    ],
  ),
);

var divider = Divider();

var bottomBtns = Padding(
  padding: const EdgeInsets.symmetric(horizontal: 30.0),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      Expanded(
        child: InkWell(
          onTap: () {},
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(50.0)),
            child: Container(
              decoration: BoxDecoration(
                  gradient: btnGradient,
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        blurRadius: 10.0,
                        color: Colors.black12,
                        offset: Offset(0.0, 10.0))
                  ]),
              height: 60.0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48.0),
                child: Center(
                  child: Text(
                    "Buy Now",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          width: 60.0,
          height: 60.0,
          decoration: BoxDecoration(
              gradient: btnGradient,
              shape: BoxShape.circle,
              boxShadow: <BoxShadow>[
                BoxShadow(
                    blurRadius: 10.0,
                    color: Colors.black12,
                    offset: Offset(0.0, 10.0))
              ]),
          child: Icon(
            Icons.add_shopping_cart,
            size: 25.0,
            color: Colors.white,
          ),
        ),
      )
    ],
  ),
);

class Mfooter extends StatefulWidget {
  @override
  _MfooterState createState() => _MfooterState();
}

class _MfooterState extends State<Mfooter>
    with SingleTickerProviderStateMixin {
  late List<Tab> _tabs;
  late List<Widget> _pages;
  static late TabController _controller;

  @override
  void initState() {
    super.initState();

    _tabs = [
      Tab(
        child: Text(
          "Product Description",
          style: TextStyle(color: Colors.black),
        ),
      ),
      Tab(
        child: Text(
          "specification",
          style: TextStyle(color: Colors.black),
        ),
      ),
      Tab(
        child: Text(
          "user reviews",
          style: TextStyle(color: Colors.black),
        ),
      ),
    ];
    _pages = [ProductDesc(), Specification(), UserReview()];
    _controller = TabController(
      length: _tabs.length,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TabBar(
          isScrollable: true,
          controller: _controller,
          tabs: _tabs,
          indicatorColor: Colors.white,
        ),
        Divider(
          height: 1.0,
        ),
        SizedBox.fromSize(
          size: const Size.fromHeight(220.0),
          child: TabBarView(
            controller: _controller,
            children: _pages,
          ),
        ),
      ],
    );
  }
}