import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spaced_repetition_software/dialog/deck_dialog.dart';
import 'package:spaced_repetition_software/model/deck.dart';
import 'package:spaced_repetition_software/context/explorer_context.dart';
import 'package:spaced_repetition_software/database/deck_card_repository.dart';

class ExplorerDeckItem extends StatelessWidget {
  final Deck deck;

  const ExplorerDeckItem({required this.deck, super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
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
