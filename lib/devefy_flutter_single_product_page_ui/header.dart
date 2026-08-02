import 'package:flutter/material.dart';
import 'clipper.dart';
import 'gredients.dart';
import 'customIcon.dart';

final Widget _appbar = Align(
  heightFactor: 0.35,
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      Padding(
        padding: const EdgeInsets.only(left: 20.0),
        child: IconButton(
          icon: Icon(
            CustomIcons.menu,
            color: Colors.black87,
          ),
          onPressed: () {
            print("menu Clicked");
          },
          splashColor: Colors.black,
        ),
      ),
      Expanded(
        child: Container(),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 20.0),
        child: Icon(
          Icons.shopping_cart,
          color: Colors.black87,
        ),
      )
    ],
  ),
);

final Widget content = Container(
  margin: const EdgeInsets.only(top: 30.0),
  child: Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      Image(
        width: 140.0,
        height: 140.0,
        image: const AssetImage("assets/googlehome.png"),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 30.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
              width: 70.0,
              height: 30.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                boxShadow: const <BoxShadow>[
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10.0,
                    offset: Offset(0.0, 10.0),
                  )
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  Icon(
                    Icons.star,
                    color: Colors.yellow,
                  ),
                  Text("4.8")
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Google Home',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontFamily: "OpenSans",
                    fontWeight: FontWeight.w300,
                    fontStyle: FontStyle.normal,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 28.0, top: 12.0),
                  child: Text(
                    "Google LLC",
                    style: TextStyle(
                      color: Colors.black87.withOpacity(.3),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              width: 60.0,
              height: 60.0,
              decoration: BoxDecoration(
                gradient: btnGradient,
                shape: BoxShape.circle,
                boxShadow: const <BoxShadow>[
                  BoxShadow(
                    blurRadius: 10.0,
                    color: Colors.black12,
                    offset: Offset(0.0, 10.0),
                  )
                ],
              ),
              child: const Icon(
                Icons.share,
                size: 25.0,
                color: Colors.white,
              ),
            ),
          ],
        ),
      )
    ],
  ),
);

class MHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280.0,
      child: Stack(
        children: <Widget>[
          ClipPath(
            clipper: ArcClipper(),
            child: Container(
              height: double.infinity,
              decoration: BoxDecoration(gradient: bgGradient),
            ),
          ),
          Align(
            alignment: FractionalOffset.center,
            heightFactor: 3.5,
            child: content,
          ),
          _appbar,
        ],
      ),
    );
  }
}