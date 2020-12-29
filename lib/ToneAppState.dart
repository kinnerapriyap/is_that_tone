import 'package:flutter/material.dart';
import 'dart:collection';
import 'package:is_that_tone/const.dart';

class ToneAppState extends ChangeNotifier {
  int _activeRound;
  Map<int, String> _rounds;
  bool _initialized = false;
  bool _error = false;

  ToneAppState()
      : _activeRound = null,
        _rounds = LinkedHashMap.fromIterable(
            List<int>.generate(MAX_ROUNDS, (i) => i + 1),
            key: (item) => item,
            value: (item) => null);

  int get activeRound => _activeRound;

  // WordCard get wordCard => _wordCard;

  Map<int, String> get rounds => _rounds;

  bool get initialized => _initialized;

  set initialized(bool isInitialized) {
    _initialized = isInitialized;
    notifyListeners();
  }

  set error(bool isError) {
    _error = isError;
    notifyListeners();
  }

  finishRound(String answer) {
    _rounds[_activeRound] = answer;
    notifyListeners();
  }

  start() {
    _activeRound = 1;
    notifyListeners();
  }

  nextRound() {
    _activeRound++;
    notifyListeners();
  }

  exit() {
    _activeRound = null;
    notifyListeners();
  }
}
