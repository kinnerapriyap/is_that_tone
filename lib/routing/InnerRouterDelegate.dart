import 'package:flutter/material.dart';
import 'package:is_that_tone/GameCardScreen.dart';
import 'package:is_that_tone/RoundOverScreen.dart';
import 'package:is_that_tone/WordCardScreen.dart';
import 'package:is_that_tone/HomeScreen.dart';
import 'package:is_that_tone/routing/ToneAppState.dart';
import 'package:is_that_tone/routing/routes.dart';

class InnerRouterDelegate extends RouterDelegate<ToneRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<ToneRoutePath> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  ToneAppState get appState => _appState;
  ToneAppState _appState;
  set appState(ToneAppState value) {
    if (value == _appState) {
      return;
    }
    _appState = value;
    notifyListeners();
  }

  InnerRouterDelegate(this._appState);

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        if (appState.activeRound == null) ...[
          MaterialPage(
            child: HomeScreen(
              onTapped: (b) => appState.start(),
            ),
            key: ValueKey('HomeScreen'),
          ),
        ] else if (appState.showWordCard) ...[
          MaterialPage(
            key: ValueKey(appState.wordCard.word),
            child: WordCardScreen(),
          ),
        ] else if (appState.roundDone) ...[
          MaterialPage(
            key: ValueKey('RoundOverScreen'),
            child: RoundOverScreen(
              onTapped: (b) => appState.nextRound(),
            ),
          ),
        ] else
          MaterialPage(
            child: GameCardScreen(
              activeRound: appState.activeRound,
              rounds: appState.rounds,
              onApplyTapped: (answer) => appState.finishRound(answer),
            ),
            key: ValueKey('GameCardScreen'),
          ),
      ],
      onPopPage: (route, result) {
        appState.exit();
        return route.didPop(result);
      },
    );
  }

  @override
  Future<void> setNewRoutePath(ToneRoutePath path) async {
    // This is not required for inner router delegate because it does not
    // parse route
    assert(false);
  }
}
