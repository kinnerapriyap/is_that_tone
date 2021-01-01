import 'package:flutter/material.dart';
import 'package:is_that_tone/GameCardScreen.dart';
import 'package:is_that_tone/HomeScreen.dart';
import 'package:is_that_tone/RoundOverScreen.dart';
import 'package:is_that_tone/StartScreen.dart';
import 'package:is_that_tone/ToneAppState.dart';
import 'package:is_that_tone/WordCardScreen.dart';
import 'const.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() => runApp(
      ChangeNotifierProvider<ToneAppState>(
        create: (context) => ToneAppState(),
        child: MyApp(),
      ),
    );

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void initializeFlutterFire() async {
    try {
      await Firebase.initializeApp();
      Future.delayed(Duration.zero, () {
        Provider.of<ToneAppState>(context).initialized = true;
      });
    } catch (e) {
      Future.delayed(Duration.zero, () {
        Provider.of<ToneAppState>(context).error = true;
      });
    }
  }

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Is that tone?',
      theme: appTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/start': (context) => StartScreen(),
        '/gameCard': (context) => GameCardScreen(),
        '/roundOver': (context) => RoundOverScreen(),
        '/wordCard': (context) => WordCardScreen(),
      },
    );
  }
}
