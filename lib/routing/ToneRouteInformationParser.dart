import 'package:flutter/material.dart';
import 'routes.dart';

class ToneRouteInformationParser extends RouteInformationParser<ToneRoutePath> {
  @override
  Future<ToneRoutePath> parseRouteInformation(
      RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location);

    if (uri.pathSegments.isNotEmpty) {
      if (uri.pathSegments.first == 'gameCard') {
        if (uri.pathSegments.length >= 2) {
          return WordCardPath(uri.pathSegments[1]);
        }
        return GameCardPath();
      } else if (uri.pathSegments.first == 'wordCard') {
        return WordCardPath(uri.pathSegments[1]);
      }
    }

    return HomePath();
  }

  @override
  RouteInformation restoreRouteInformation(ToneRoutePath configuration) {
    if (configuration is HomePath) {
      return RouteInformation(location: '/home');
    }
    if (configuration is GameCardPath) {
      return RouteInformation(location: '/gameCard');
    }
    if (configuration is WordCardPath) {
      return RouteInformation(location: '/wordCard/${configuration.word}');
    }
    return null;
  }
}
