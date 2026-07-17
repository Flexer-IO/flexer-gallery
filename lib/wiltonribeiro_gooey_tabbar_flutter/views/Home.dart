import 'package:flutter/material.dart';
import '../components/MenuTabBar.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _Home createState() => _Home();
}

class _Home extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Center(
              child: const Text(
                "View",
                style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
              ),
            ),
            MenuTabBar(
              background: Colors.blue,
              iconButtons: [
                IconButton(
                  color: Colors.blue,
                  icon: const Icon(Icons.home, size: 30),
                  onPressed: () {},
                ),
                IconButton(
                  color: Colors.blue,
                  icon: const Icon(Icons.search, size: 30),
                  onPressed: () {},
                ),
                IconButton(
                  color: Colors.blue,
                  icon: const Icon(Icons.map, size: 30),
                  onPressed: () {},
                ),
                IconButton(
                  color: Colors.blue,
                  icon: const Icon(Icons.favorite, size: 30),
                  onPressed: () {},
                ),
              ],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: const Text(
                      "Reminder",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    margin: const EdgeInsets.all(10),
                  ),
                  Container(
                    child: const Text(
                      "Camera",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    margin: const EdgeInsets.all(10),
                  ),
                  Container(
                    child: const Text(
                      "Attchment",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    margin: const EdgeInsets.all(10),
                  ),
                  Container(
                    child: const Text(
                      "Text Note",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    margin: const EdgeInsets.all(10),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}