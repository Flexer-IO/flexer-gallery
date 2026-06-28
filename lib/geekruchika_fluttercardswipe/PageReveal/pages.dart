import 'package:flutter/material.dart';

final List<PageViewModel> pages = [
  PageViewModel(Colors.blue, Icons.phone, Icons.contacts, "This is subtitle", "Contact"),
  PageViewModel(Colors.red, Icons.chat_bubble, Icons.chat, "This is subtitle", "Chat"),
  PageViewModel(Colors.green, Icons.hotel, Icons.home, "This is subtitle", "Home"),
];

class Page extends StatelessWidget {
  final PageViewModel viewModel;
  final double percentVisible;

  const Page({required this.viewModel, this.percentVisible = 1.0, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: viewModel.color,
      child: Opacity(
        opacity: percentVisible,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Transform(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 25.0),
                child: Icon(
                  viewModel.iconName,
                  size: 150.0,
                  color: Colors.white,
                ),
              ),
              transform: Matrix4.translationValues(0.0, 50.0 * (1.0 - percentVisible), 0.0),
            ),
            Transform(
              transform: Matrix4.translationValues(0.0, 30.0 * (1.0 - percentVisible), 0.0),
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Text(
                  viewModel.title,
                  style: const TextStyle(fontSize: 34.0, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Transform(
              transform: Matrix4.translationValues(0.0, 30.0 * (1.0 - percentVisible), 0.0),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 75.0),
                child: Text(
                  viewModel.subtitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18.0, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PageViewModel {
  final Color color;
  final IconData iconName;
  final String title;
  final String subtitle;
  final IconData iconAssetIcon;

  PageViewModel(this.color, this.iconAssetIcon, this.iconName, this.subtitle, this.title);
}