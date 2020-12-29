abstract class ToneRoutePath {}

class GameCardPath extends ToneRoutePath {}

class WordCardPath extends ToneRoutePath {
  final String word;
  WordCardPath(this.word);
}

class HomePath extends ToneRoutePath {}

class RoundOverPath extends ToneRoutePath {}
