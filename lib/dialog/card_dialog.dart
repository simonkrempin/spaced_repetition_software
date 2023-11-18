import "dart:typed_data";

import "package:flutter/material.dart"
    show
        AlertDialog,
        BuildContext,
        Column,
        FilledButton,
        Icon,
        IconButton,
        Icons,
        InputDecoration,
        MainAxisAlignment,
        MainAxisSize,
        Navigator,
        OutlineInputBorder,
        Row,
        SizedBox,
        State,
        StatefulWidget,
        Text,
        TextButton,
        TextEditingController,
        TextField,
        Widget;
import "package:provider/provider.dart";
import "package:spaced_repetition_software/context/explorer_context.dart";
import "package:spaced_repetition_software/database/card_repository.dart";
import "package:spaced_repetition_software/models/card.dart";
import "package:image_picker/image_picker.dart";

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
  late final int deckId = widget.providerContext.read<ExplorerContext>().deckId;

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
            maxLines: null,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Front",
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              TextField(
                controller: backController,
                maxLines: null,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Back",
                ),
              ),
              IconButton(
                onPressed: () {
                  pickImage();
                },
                icon: const Icon(Icons.attach_file),
              ),
            ],
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

  Future<Uint8List?> pickImage() async {
    final ImagePicker imagePicker = ImagePicker();
    final XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return await pickedFile.readAsBytes();
    }
    return null;
  }
}
