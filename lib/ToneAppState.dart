import 'package:flutter/material.dart';

class ToneAppState extends ChangeNotifier {
  bool _initialized = false;
  bool _error = false;
  String room;
  int maxRounds = 2;
  bool isCreator = false;

  bool get initialized => _initialized;

  set initialized(bool isInitialized) {
    _initialized = isInitialized;
    notifyListeners();
  }

  set error(bool isError) {
    _error = isError;
    notifyListeners();
  }
}
