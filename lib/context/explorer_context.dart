import "package:flutter/material.dart" show ChangeNotifier;
import "dart:async";

import "package:spaced_repetition_software/model/deck.dart";
import "package:spaced_repetition_software/model/card.dart";
import "package:spaced_repetition_software/model/deck_content.dart";
import "package:spaced_repetition_software/database/card_repository.dart";
import "package:spaced_repetition_software/database/deck_repository.dart";

class ExplorerContext with ChangeNotifier {
  final Map<int, DeckContent> _deckCache = {};
  final Map<int, bool> _deckCacheValidState = {};
  final List<Deck> _deckTrace = [Deck(id: 0, parentId: 0, name: "Home")];

  int get deckId {
    return _deckTrace.last.id;
  }

  String get deckName {
    return _deckTrace.last.name;
  }

  Deck get parentDeck {
    if (_deckTrace.length > 1) {
      return _deckTrace[_deckTrace.length - 2];
    }

    return _deckTrace.last;
  }

  set deck(Deck deckToAdd) {
    _deckTrace.add(deckToAdd);
    notifyListeners();
  }

  void returnHome() {
    _deckTrace.clear();
    _deckTrace.add(Deck(id: 0, parentId: 0, name: "Home"));
    notifyListeners();
  }

  void goBackInDeck() {
    if (_deckTrace.length > 1) {
      _deckTrace.removeLast();
      notifyListeners();
    }
  }

  void invalidateCache([int deckId = -1]) {
    if (deckId == -1) {
      _deckCacheValidState[this.deckId] = false;
    } else {
      _deckCacheValidState[deckId] = false;
    }
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
