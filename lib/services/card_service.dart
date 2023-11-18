import 'package:flutter/material.dart' show BuildContext;
import 'package:provider/provider.dart';
import 'package:spaced_repetition_software/context/explorer_context.dart';
import 'package:spaced_repetition_software/database/card_repository.dart';
import 'package:spaced_repetition_software/models/card.dart';
import 'package:spaced_repetition_software/models/deck.dart';

void moveCard(BuildContext context, Deck targetDeck, Card droppedCard) async {
  droppedCard.deckId = targetDeck.id;
  updateCard(droppedCard);
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
