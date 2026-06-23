import 'package:flutter/material.dart';
import 'clock.dart';

void main() => runApp(
  MaterialApp(
    home: Clock(),
    //use open sans as a font
    theme: ThemeData(fontFamily: 'Open Sans'),
  )
);

