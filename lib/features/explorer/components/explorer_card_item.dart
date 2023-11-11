import "package:flutter/material.dart"
    show
        BorderRadius,
        BuildContext,
        CircleAvatar,
        Icon,
        Icons,
        ListTile,
        RoundedRectangleBorder,
        StatelessWidget,
        Text,
        Colors,
        Theme,
        Widget,
        VoidCallback,
        showDialog;
import "package:spaced_repetition_software/dialog/card_dialog.dart";
import "package:spaced_repetition_software/model/card.dart";
import "package:spaced_repetition_software/services/file_explorer.dart";

class ExplorerCardItem extends StatelessWidget {
  final Card card;

  const ExplorerCardItem({required this.card, super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        child: const Icon(Icons.file_copy_outlined, color: Colors.white),
      ),
      title: Text(card.front),
      trailing: const Icon(Icons.more_vert),
      onTap: () => showEditingDialog(context),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      tileColor: Theme.of(context).cardColor,
    );
  }

  void showEditingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (alertDialogContext) => CardDialog(
        card: card,
        onSaved: (String front, String back) {
          card.front = front;
          card.back = back;
          updateCard(card);
        },
        providerContext: context,
      ),
    );
  }
}
