import 'package:flutter/material.dart';

const blinkInterval = 10; // In seconds

enum Entity {
  background,
  indications,
  leaf,
  tongue,
  eyes,
  body,
  spring,
  summer,
  fall,
  winter,
}

final lightTheme = {
  Entity.background: Colors.white,
  Entity.indications: Colors.grey,
  Entity.leaf: Colors.lightGreen,
  Entity.tongue: Colors.red.shade700,
  Entity.eyes: Colors.black,
  Entity.body: null,
  Entity.spring: Colors.green.shade400,
  Entity.summer: Colors.amber.shade200,
  Entity.fall: Colors.orange,
  Entity.winter: Colors.blue.shade300,
};

final darkTheme = {
  Entity.background: Colors.black,
  Entity.indications: Colors.grey,
  Entity.leaf: Colors.lightGreen,
  Entity.tongue: Colors.red.shade700,
  Entity.eyes: Colors.black,
  Entity.body: null,
  Entity.spring: Colors.green.shade400,
  Entity.summer: Colors.amber.shade200,
  Entity.fall: Colors.orange,
  Entity.winter: Colors.blue.shade300,
};

enum Season { spring, summer, fall, winter }

final seasons = {
  Season.spring: DateTime(0, 3, 1),
  Season.summer: DateTime(0, 6, 1),
  Season.fall: DateTime(0, 9, 1),
  Season.winter: DateTime(0, 12, 1),
};

enum Apple { red, green, yellow }

final appleColors = {
  Apple.yellow: Colors.amber,
  Apple.red: Colors.red,
  Apple.green: Colors.green,
};

class SnakePalette {
  final String name;
  final Map<Entity, Color?> colors;
  const SnakePalette({required this.name, required this.colors});
}

final snakePalettes = [
  SnakePalette(
    name: 'Midnight Green',
    colors: {
      Entity.background: Colors.black,
      Entity.indications: Colors.grey,
      Entity.body: Colors.green.shade400,
      Entity.leaf: Colors.lightGreen,
      Entity.tongue: Colors.red.shade700,
      Entity.eyes: Colors.white,
    },
  ),
  SnakePalette(
    name: 'Sunset',
    colors: {
      Entity.background: const Color(0xff120806),
      Entity.indications: Colors.grey,
      Entity.body: Colors.orange,
      Entity.leaf: Colors.lightGreen,
      Entity.tongue: Colors.red.shade700,
      Entity.eyes: Colors.white,
    },
  ),
  SnakePalette(
    name: 'Ocean',
    colors: {
      Entity.background: const Color(0xff0a1628),
      Entity.indications: Colors.blueGrey,
      Entity.body: Colors.cyan.shade400,
      Entity.leaf: Colors.teal.shade300,
      Entity.tongue: Colors.red.shade400,
      Entity.eyes: Colors.white,
    },
  ),
  SnakePalette(
    name: 'Sakura',
    colors: {
      Entity.background: const Color(0xff1a0a0e),
      Entity.indications: Colors.grey,
      Entity.body: Colors.pink.shade300,
      Entity.leaf: Colors.pink.shade100,
      Entity.tongue: Colors.red.shade300,
      Entity.eyes: Colors.white,
    },
  ),
  SnakePalette(
    name: 'Gold',
    colors: {
      Entity.background: Colors.black,
      Entity.indications: Colors.grey,
      Entity.body: Colors.amber.shade400,
      Entity.leaf: Colors.lightGreen,
      Entity.tongue: Colors.red.shade700,
      Entity.eyes: Colors.white,
    },
  ),
  SnakePalette(
    name: 'Light',
    colors: {
      Entity.background: Colors.white,
      Entity.indications: Colors.grey.shade400,
      Entity.body: Colors.green.shade600,
      Entity.leaf: Colors.lightGreen,
      Entity.tongue: Colors.red.shade700,
      Entity.eyes: Colors.black,
    },
  ),
];
