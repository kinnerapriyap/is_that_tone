import 'package:flutter/material.dart';

import 'const.dart';
import 'routing/ToneRouterDelegate.dart';
import 'routing/ToneRouteInformationParser.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ToneRouterDelegate _routerDelegate = ToneRouterDelegate();
  ToneRouteInformationParser _routeInformationParser =
      ToneRouteInformationParser();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Is that tone?',
      theme: ThemeData(
        primarySwatch: themeColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routerDelegate: _routerDelegate,
      routeInformationParser: _routeInformationParser,
    );
  }
}
