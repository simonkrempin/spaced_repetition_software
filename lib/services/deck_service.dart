import 'package:flutter/material.dart' show BuildContext;
import 'package:provider/provider.dart';
import 'package:spaced_repetition_software/context/explorer_context.dart';
import 'package:spaced_repetition_software/database/card_repository.dart';
import 'package:spaced_repetition_software/database/deck_repository.dart';
import 'package:spaced_repetition_software/models/deck.dart';

void moveDeck(BuildContext context, Deck targetDeck, Deck droppedDeck) async {
  droppedDeck.parentId = targetDeck.id;
  updateDeck(droppedDeck);
  context.read<ExplorerContext>().invalidateCache(targetDeck.id);
  context.read<ExplorerContext>().invalidateCache();
}

void deleteDeck(BuildContext context, Deck parentDeck) async {
  Future<List<int>> collectDeckIds(int deckId) async {
    List<int> collectedIds = [deckId];
    var subDecks = await getDecks(deckId);
    for (var subDeck in subDecks) {
      collectedIds.addAll(await collectDeckIds(subDeck.id));
    }
    return collectedIds;
  }

  List<int> allDeckIds = await collectDeckIds(parentDeck.id);

  await Future.wait([
    ...allDeckIds.map(deleteDeckById),
    ...allDeckIds.map(deleteCardsByDeckId),
  ]);

  // same here
  if (context.mounted) {
    context.read<ExplorerContext>().invalidateCache();
  }
}
