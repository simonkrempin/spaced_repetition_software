import "dart:typed_data";

import "package:flutter/material.dart";
import "package:spaced_repetition_software/dialog/card_dialog.dart";
import "package:spaced_repetition_software/models/card.dart" as models;
import "package:spaced_repetition_software/database/card_repository.dart";
import "package:spaced_repetition_software/services/card_service.dart";

class ExplorerCardItem extends StatelessWidget {
  final models.Card card;

  const ExplorerCardItem({required this.card, super.key});

  @override
  Widget build(BuildContext context) {
    var listTile = ListTile(
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        child: const Icon(
          Icons.file_copy_outlined,
          color: Colors.white,
        ),
      ),
      title: Text(card.front),
      trailing: MenuAnchor(
        menuChildren: [
          MenuItemButton(child: const Text("Delete"), onPressed: () => deleteCard(context, card)),
        ],
        builder: (BuildContext context, MenuController controller, Widget? child) => IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () {
            controller.isOpen ? controller.close() : controller.open();
          },
        ),
      ),
      onTap: () => showEditingDialog(context),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      tileColor: Theme.of(context).cardColor,
    );

    return LongPressDraggable(
      data: card,
      feedback: SizedBox(
        width: MediaQuery.of(context).size.width - 16,
        height: 64,
        child: Card(child: listTile),
      ),
      child: listTile,
    );
  }

  void showEditingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (alertDialogContext) => CardDialog(
        card: card,
        onSaved: (String front, String? backText, Uint8List? backImage) {
          card.front = front;
          card.backText = backText;
          card.backImage = backImage;
          updateCard(card);
        },
        providerContext: context,
      ),
    );
  }

  void showContextMenu() {}
}
