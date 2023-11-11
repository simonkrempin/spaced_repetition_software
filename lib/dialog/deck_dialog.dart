import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:spaced_repetition_software/context/explorer_context.dart";
import "package:spaced_repetition_software/services/file_explorer.dart";

class DeckDialog extends StatefulWidget {
  final BuildContext providerContext;

  const DeckDialog({ required this.providerContext, super.key});

  @override
  State<StatefulWidget> createState() => _DeckDialogState();
}

class _DeckDialogState extends State<DeckDialog> {
  final nameController = TextEditingController();
  late final int deckId;

  void saveDeck() {
    var name = nameController.text;
    print(deckId);
    addDeck(name, deckId);
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
                child: const Text("create"),
              ),
            ],
          )
        ],
      ),
    );
  }
}
