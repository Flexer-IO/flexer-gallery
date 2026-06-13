import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/services.dart';
import 'src/custom_carousel.dart';
import 'src/custom_carousel_scroll_controller.dart';
import 'src/custom_carousel_scroll_physics.dart';

class GskinnerteamFlutterCustomCarouselPage extends StatefulWidget {
  const GskinnerteamFlutterCustomCarouselPage({super.key});

  @override
  State<GskinnerteamFlutterCustomCarouselPage> createState() => _GskinnerteamFlutterCustomCarouselPageState();
}

class _GskinnerteamFlutterCustomCarouselPageState extends State<GskinnerteamFlutterCustomCarouselPage> {
  final CustomCarouselScrollController _scrollController = CustomCarouselScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      body: Center(
        child: CustomCarousel(
          scrollDirection: Axis.horizontal,
          effectsBuilder: (context, scrollRatio, child) {
            return Transform.scale(
              scale: 1 - (scrollRatio.abs() * 0.2),
              child: child,
            );
          },
          children: List.generate(
            10,
            (index) => Container(
              width: 200,
              height: 200,
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  'Item $index',
                  style: const TextStyle(fontSize: 24, color: Colors.white),
                ),
              ),
            ),
          ),
          controller: _scrollController,
          physics: const CustomCarouselScrollPhysics(sticky: true),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              _scrollController.previousItem();
            },
            child: const Icon(Icons.arrow_back),
          ),
          const SizedBox(width: 10),
          FloatingActionButton(
            onPressed: () {
              _scrollController.nextItem();
            },
            child: const Icon(Icons.arrow_forward),
          ),
        ],
      ),
    );
  }
}