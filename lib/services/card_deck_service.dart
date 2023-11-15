import 'package:flutter/material.dart' show BuildContext;
import 'package:provider/provider.dart';
import 'package:spaced_repetition_software/context/explorer_context.dart';
import 'package:spaced_repetition_software/database/deck_card_repository.dart';
import 'package:spaced_repetition_software/model/card.dart';
import 'package:spaced_repetition_software/model/deck.dart';

void moveCard(BuildContext context, Deck targetDeck, Card droppedCard) async {
  droppedCard.deckId = targetDeck.id;
  updateCard(droppedCard);
  context.read<ExplorerContext>().invalidateCache(targetDeck.id);
  context.read<ExplorerContext>().invalidateCache();
}

void moveDeck(BuildContext context, Deck targetDeck, Deck droppedDeck) async {
  droppedDeck.parentId = targetDeck.id;
  updateDeck(droppedDeck);
  context.read<ExplorerContext>().invalidateCache(targetDeck.id);
  context.read<ExplorerContext>().invalidateCache();
}

void deleteCard(BuildContext context, Card card) async {
  await deleteCardById(card.id!);

  // I am not sure if this is right here because the cache should be invalidated for all decks even if the widget is not
  // mounted anymore. But I assume the context for the provider stays mounted, which makes this check valid.
  if (context.mounted) {
    context.read<ExplorerContext>().invalidateCache();
  }
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
