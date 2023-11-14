import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spaced_repetition_software/dialog/deck_dialog.dart';
import 'package:spaced_repetition_software/model/deck.dart';
import 'package:spaced_repetition_software/model/card.dart' as models;
import 'package:spaced_repetition_software/context/explorer_context.dart';
import 'package:spaced_repetition_software/database/deck_card_repository.dart';
import 'package:spaced_repetition_software/services/card_deck_service.dart';

class ExplorerDeckItem extends StatelessWidget {
  final Deck deck;

  const ExplorerDeckItem({required this.deck, super.key});

  @override
  Widget build(BuildContext context) {
    var listTile = ListTile(
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        child: const Icon(
          Icons.folder_outlined,
          color: Colors.white,
        ),
      ),
      title: Text(deck.name),
      trailing: IconButton(
        icon: const Icon(Icons.more_vert),
        onPressed: () {
          showEditingDialog(context);
        },
      ),
      onTap: () {
        context.read<ExplorerContext>().deckId = deck.id;
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      tileColor: Theme.of(context).cardColor,
    );

    return LongPressDraggable(
      data: deck,
      feedback: SizedBox(
        width: MediaQuery.of(context).size.width - 16,
        height: 64,
        child: Card(child: listTile),
      ),
      child: DragTarget(
        builder: (context, candidateData, rejectedItems) => listTile,
        onAccept: (droppedItem) {
          if (droppedItem is Deck) {
            if (droppedItem.id == deck.id) return;
            moveDeck(context, deck, droppedItem);
          } else if (droppedItem is models.Card) {
            moveCard(context, deck, droppedItem);
          } else {
            throw Exception("Unknown type");
          }
        },
      ),
    );
  }

  void showEditingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (alertDialogContext) => DeckDialog(
        deck: deck,
        onSaved: (String name) {
          deck.name = name;
          updateDeck(deck);
        },
        providerContext: context,
      ),
    );
  }
}
