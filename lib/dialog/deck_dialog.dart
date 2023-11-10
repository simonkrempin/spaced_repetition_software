import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:spaced_repetition_software/context/explorer_context.dart";
import "package:spaced_repetition_software/services/file_explorer.dart";

class DeckDialog extends StatefulWidget {
  final int deckId;
  final BuildContext providerContext;

  const DeckDialog({ required this.providerContext, required this.deckId, super.key});

  @override
  State<StatefulWidget> createState() => _DeckDialogState();
}

class _DeckDialogState extends State<DeckDialog> {
  final nameController = TextEditingController();

  void saveDeck() {
    var name = nameController.text;

    addDeck(name, widget.deckId);
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
                  widget.providerContext.read<ExplorerContext>().invalidateCache(widget.deckId);
                  Navigator.of(context).pop();
                },
                child: const Text("create"),
              ),
            ],
          )
        ],
      ),
    );
  }
}
