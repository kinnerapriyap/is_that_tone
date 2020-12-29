import 'package:flutter/material.dart';
import 'package:is_that_tone/routing/ToneAppState.dart';
import 'routes.dart';
import 'AppShell.dart';

class ToneRouterDelegate extends RouterDelegate<ToneRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<ToneRoutePath> {
  final GlobalKey<NavigatorState> navigatorKey;

  ToneAppState appState = ToneAppState();

  ToneRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>() {
    appState.addListener(notifyListeners);
  }

  ToneRoutePath get currentConfiguration {
    if (appState.activeRound == null) {
      return HomePath();
    } else if (appState.showWordCard) {
      return WordCardPath(appState.wordCard.word);
    } else if (appState.roundDone) {
      return RoundOverPath();
    } else {
      return GameCardPath();
    }
  }

  @override
  Widget build(BuildContext context) => Navigator(
        key: navigatorKey,
        pages: [
          MaterialPage(
            child: AppShell(appState: appState),
          ),
        ],
        onPopPage: (route, result) {
          if (!route.didPop(result)) {
            return false;
          }
          appState.exit();
          return true;
        },
      );

  @override
  Future<void> setNewRoutePath(ToneRoutePath path) {
    if (path is GameCardPath) {
      //appState.selectedIndex = 0;
      //appState.selectedBook = null;
    } else if (path is WordCardPath) {
      //appState.selectedIndex = 1;
    } else if (path is HomePath) {
      //appState.setSelectedBookById(path.id);
    }
  }
}
