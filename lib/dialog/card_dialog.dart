import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:spaced_repetition_software/context/explorer_context.dart";
import "package:spaced_repetition_software/services/file_explorer.dart";

class CardDialog extends StatefulWidget {
  final BuildContext providerContext;

  const CardDialog({required this.providerContext, super.key});

  @override
  State<StatefulWidget> createState() => _CardDialogState();
}

class _CardDialogState extends State<CardDialog> {
  final frontController = TextEditingController();
  final backController = TextEditingController();
  late final int deckId;

  void saveCard() {
    var front = frontController.text;
    var back = backController.text;

    addCard(front, back, deckId);
  }

  @override
  void initState() {
    super.initState();
    deckId = widget.providerContext.read<ExplorerContext>().deckId;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("create new card"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: frontController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Front",
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: backController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Back",
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
                  saveCard();
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
