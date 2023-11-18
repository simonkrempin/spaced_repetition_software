import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:spaced_repetition_software/context/explorer_context.dart";
import "package:spaced_repetition_software/models/deck.dart";
import "package:spaced_repetition_software/database/deck_repository.dart";

typedef SaveFunction = void Function(String name);

class DeckDialog extends StatefulWidget {
  final BuildContext providerContext;
  final Deck? deck;
  final SaveFunction? onSaved;

  const DeckDialog({ this.deck, this.onSaved, required this.providerContext, super.key});

  @override
  State<StatefulWidget> createState() => _DeckDialogState();
}

class _DeckDialogState extends State<DeckDialog> {
  late final nameController = TextEditingController(text: widget.deck != null ? widget.deck!.name : "");
  late final int deckId;

  void saveDeck() {
    var name = nameController.text;
    widget.onSaved != null ? widget.onSaved!(name) : addDeck(name, deckId);
  }

  @override
  void initState() {
    super.initState();
    deckId = widget.providerContext.read<ExplorerContext>().deckId;
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("create new folder"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Folder Name',
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("cancel"),
              ),
              const SizedBox(width: 8),
              FilledButton(
                onPressed: () {
                  saveDeck();
                  widget.providerContext.read<ExplorerContext>().invalidateCache(deckId);
                  Navigator.of(context).pop();
                },
                child: Text(widget.onSaved != null ? "save" : "create"),
              ),
            ],
          )
        ],
      ),
    );
  }
}
