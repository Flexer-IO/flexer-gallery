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
      Entity.indications: Colors.grey.shade700,
      Entity.body: Colors.green.shade400,
      Entity.leaf: Colors.lightGreen,
      Entity.tongue: Colors.red.shade700,
      Entity.eyes: Colors.black,
    },
  ),
  SnakePalette(
    name: 'Inferno',
    colors: {
      Entity.background: const Color(0xff0d0200),
      Entity.indications: Colors.grey.shade800,
      Entity.body: Colors.deepOrange.shade400,
      Entity.leaf: Colors.orange.shade300,
      Entity.tongue: Colors.red.shade900,
      Entity.eyes: Colors.black,
    },
  ),
  SnakePalette(
    name: 'Ocean',
    colors: {
      Entity.background: const Color(0xff020d1a),
      Entity.indications: Colors.blueGrey.shade800,
      Entity.body: Colors.cyan.shade400,
      Entity.leaf: Colors.teal.shade300,
      Entity.tongue: Colors.red.shade400,
      Entity.eyes: Colors.black,
    },
  ),
  SnakePalette(
    name: 'Sakura',
    colors: {
      Entity.background: const Color(0xff0d0206),
      Entity.indications: Colors.grey.shade800,
      Entity.body: Colors.pink.shade300,
      Entity.leaf: Colors.pink.shade200,
      Entity.tongue: Colors.red.shade400,
      Entity.eyes: Colors.black,
    },
  ),
  SnakePalette(
    name: 'Gold',
    colors: {
      Entity.background: const Color(0xff0d0900),
      Entity.indications: Colors.grey.shade800,
      Entity.body: Colors.amber.shade400,
      Entity.leaf: Colors.lightGreen,
      Entity.tongue: Colors.red.shade700,
      Entity.eyes: Colors.black,
    },
  ),
  SnakePalette(
    name: 'Violet',
    colors: {
      Entity.background: const Color(0xff08010d),
      Entity.indications: Colors.grey.shade800,
      Entity.body: Colors.purple.shade300,
      Entity.leaf: Colors.purpleAccent.shade100,
      Entity.tongue: Colors.red.shade400,
      Entity.eyes: Colors.black,
    },
  ),
  SnakePalette(
    name: 'Matrix',
    colors: {
      Entity.background: Colors.black,
      Entity.indications: const Color(0xff003300),
      Entity.body: const Color(0xff00ff41),
      Entity.leaf: const Color(0xff00cc33),
      Entity.tongue: Colors.red.shade700,
      Entity.eyes: Colors.black,
    },
  ),
];
