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