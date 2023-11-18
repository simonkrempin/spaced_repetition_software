import "dart:typed_data";

import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:spaced_repetition_software/components/divider_with_text.dart";
import "package:spaced_repetition_software/context/explorer_context.dart";
import "package:spaced_repetition_software/database/card_repository.dart";
import "package:spaced_repetition_software/models/card.dart" as models;
import "package:image_picker/image_picker.dart";

typedef SaveCallback = void Function(String front, String? backText, Uint8List? backImage);

class CardDialog extends StatefulWidget {
  final BuildContext providerContext;
  final models.Card? card;
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
  late final backController = TextEditingController(text: widget.card != null ? widget.card!.backText : "");
  late final int deckId = widget.providerContext.read<ExplorerContext>().deckId;
  late Uint8List? backImage = widget.card?.backImage;
  late bool showBackImageSelector = backController.text == "" && backImage == null;
  late bool showTextSelector = widget.card?.backImage == null;

  void saveCard() {
    var front = frontController.text;
    var backText = backController.text == "" ? null : backController.text;

    widget.onSaved == null ? addCard(front, backText, backImage, deckId) : widget.onSaved!(front, backText, backImage);
  }

  @override
  void initState() {
    super.initState();

    backController.addListener(() {
      setState(() {
        showBackImageSelector = backController.text == "";
      });
    });
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
          if (showTextSelector)
            TextField(
              controller: backController,
              maxLines: null,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Back",
              ),
            ),
          const SizedBox(height: 8),
          if (showBackImageSelector)
            const DividerWithText(text: "or"),
          if (showBackImageSelector)
            TextButton.icon(
              onPressed: () {
                pickImage().then((value) {
                  setState(() {
                    backImage = value;
                    showTextSelector = false;
                    showBackImageSelector = false;
                  });
                });
              },
              label: const Text("Upload Image"),
              icon: const Icon(Icons.attach_file),
            ),
          if (backImage != null)
            Image.memory(
              backImage!,
              fit: BoxFit.cover,
              height: 200,
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
