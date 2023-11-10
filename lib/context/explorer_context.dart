import "package:provider/provider.dart" ;
import "package:flutter/material.dart" show ChangeNotifier;
import "dart:async";

import "package:spaced_repetition_software/model/deck.dart";
import "package:spaced_repetition_software/model/card.dart";
import "package:spaced_repetition_software/model/deck_content.dart";
import "package:spaced_repetition_software/services/file_explorer.dart";

class ExplorerContext with ChangeNotifier {
  late int _deckId;
  final Map<int, DeckContent> _deckCache = {};
  final Map<int, bool> _deckCacheValidState = {};

  int get deckId => _deckId;
  set deckId(int value) {
    _deckId = value;
    notifyListeners();
  }

  void invalidateCache(int deckId) {
    _deckCacheValidState[deckId] = false;
  }

  Future<DeckContent> getDeckContent() async {
    if (_deckCache.containsKey(_deckId) && _deckCacheValidState[_deckId]!) {
      return _deckCache[_deckId]!;
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

  ExplorerContext({required int deckId}) {
    _deckId = deckId;
  }
}