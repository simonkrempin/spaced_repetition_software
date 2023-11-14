import "package:flutter/material.dart" show ChangeNotifier;
import "dart:async";

import "package:spaced_repetition_software/model/deck.dart";
import "package:spaced_repetition_software/model/card.dart";
import "package:spaced_repetition_software/model/deck_content.dart";
import "package:spaced_repetition_software/database/deck_card_repository.dart";

class ExplorerContext with ChangeNotifier {
  final Map<int, DeckContent> _deckCache = {};
  final Map<int, bool> _deckCacheValidState = {};
  final List<int> _deckIdTrace = [];

  int get deckId {
    if (_deckIdTrace.isEmpty) {
      return 0;
    }

    return _deckIdTrace.last;
  }

  set deckId(int value) {
    _deckIdTrace.add(value);
    notifyListeners();
  }

  void goBackInDeck() {
    if (_deckIdTrace.isNotEmpty) {
      _deckIdTrace.removeLast();
      notifyListeners();
    }
  }

  void invalidateCache([int deckId = 0]) {
    _deckCacheValidState[deckId] = false;
    notifyListeners();
  }

  Future<DeckContent> getDeckContent() async {
    if (_deckCache.containsKey(deckId) && _deckCacheValidState[deckId]!) {
      return _deckCache[deckId]!;
    }

    return _fetchData();
  }

  Future<DeckContent> _fetchData() {
    final completer = Completer<DeckContent>();
    final decksFuture = getDecks(deckId);
    final cardsFuture = getCards(deckId);

    Future.wait([decksFuture, cardsFuture]).then((result) {
      List<Deck> decksResult = result[0] as List<Deck>;
      List<Card> cardsResult = result[1] as List<Card>;

      final deckContent = DeckContent(decks: decksResult, cards: cardsResult);
      _deckCache[deckId] = deckContent;
      _deckCacheValidState[deckId] = true;

      completer.complete(deckContent);
    });

    return completer.future;
  }
}
