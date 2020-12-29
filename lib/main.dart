import 'package:flutter/material.dart';
import 'package:is_that_tone/GameCardScreen.dart';
import 'package:is_that_tone/HomeScreen.dart';
import 'package:is_that_tone/RoundOverScreen.dart';
import 'package:is_that_tone/WordCardScreen.dart';
import 'const.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Is that tone?',
      theme: ThemeData(
        primarySwatch: themeColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/gameCard': (context) => GameCardScreen(),
        '/roundOver': (context) => RoundOverScreen(),
        '/wordCard': (context) => WordCardScreen(),
      },
    );
  }
}
