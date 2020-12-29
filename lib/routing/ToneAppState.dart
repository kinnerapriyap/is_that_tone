import 'package:flutter/material.dart';
import '../WordCardScreen.dart';
import 'dart:collection';
import 'package:is_that_tone/const.dart';

class ToneAppState extends ChangeNotifier {
  int _activeRound;

  bool _roundDone;

  WordCard _wordCard;

  bool _showWordCard;

  Map<int, String> _rounds;

  final List<WordCard> wordCards = [
    WordCard('sare', {'A': "happy", 'B': "sad"}),
    WordCard('edo', {'A': "happy", 'B': "sad"}),
    WordCard('inka', {'A': "happy", 'B': "sad"}),
  ];

  ToneAppState()
      : _activeRound = null,
        _roundDone = false,
        _showWordCard = false,
        _rounds = LinkedHashMap.fromIterable(
            List<int>.generate(MAX_ROUNDS, (i) => i + 1),
            key: (item) => item,
            value: (item) => null);

  int get activeRound => _activeRound;

  bool get showWordCard => _showWordCard;

  WordCard get wordCard => _wordCard;

  bool get roundDone => _roundDone;

  Map<int, String> get rounds => _rounds;

  set showWordCard(bool show) {
    _showWordCard = show;
    notifyListeners();
  }

  finishRound(String answer) {
    _roundDone = true;
    _rounds[_activeRound] = answer;
    notifyListeners();
  }

  start() {
    _activeRound = 1;
    _roundDone = false;
    notifyListeners();
  }

  nextRound() {
    _activeRound++;
    _roundDone = false;
    notifyListeners();
  }

  exit() {
    _activeRound = null;
    _roundDone = false;
    notifyListeners();
  }
}
