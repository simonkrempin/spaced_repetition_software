import "package:flutter/material.dart"
    show AlertDialog, BuildContext, Column, FilledButton, InputDecoration, MainAxisAlignment, MainAxisSize, Navigator, OutlineInputBorder, Row, SizedBox, State, StatefulWidget, Text, TextButton, TextEditingController, TextField, VoidCallback, Widget;
import "package:provider/provider.dart";
import "package:spaced_repetition_software/context/explorer_context.dart";
import "package:spaced_repetition_software/services/file_explorer.dart";
import "package:spaced_repetition_software/model/card.dart";

typedef SaveCallback = void Function(String front, String back);

class CardDialog extends StatefulWidget {
  final BuildContext providerContext;
  final Card? card;
  final SaveCallback? onSaved;

  const CardDialog({
    this.card,
    this.onSaved,
    required this.providerContext,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _CardDialogState();
}

class _CardDialogState extends State<CardDialog> {
  late final frontController = TextEditingController(text: widget.card != null ? widget.card!.front : "");
  late final backController = TextEditingController(text: widget.card != null ? widget.card!.back : "");
  late final int deckId = widget.providerContext
      .read<ExplorerContext>()
      .deckId;

  void saveCard() {
    var front = frontController.text;
    var back = backController.text;

    widget.onSaved == null ? addCard(front, back, deckId) : widget.onSaved!(front, back);
  }

  @override
  void initState() {
    super.initState();
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
                child: Text(widget.onSaved == null ? "create" : "save"),
              ),
            ],
          )
        ],
      ),
    );
  }
}
