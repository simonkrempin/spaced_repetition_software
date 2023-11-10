import 'package:flutter/material.dart';
import "package:spaced_repetition_software/services/file_explorer.dart";

class CardDialog extends StatelessWidget {
  final int deckId;

  CardDialog({ required this.deckId, super.key});

  final frontController = TextEditingController();
  final backController = TextEditingController();

  void saveCard() {
    var front = frontController.text;
    var back = backController.text;

    addCard(front, back, deckId);
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