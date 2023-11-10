import "package:flutter/material.dart" show BorderRadius, BuildContext, CircleAvatar, Icon, Icons, ListTile, RoundedRectangleBorder, StatelessWidget, Text, Theme, Widget;
import "package:spaced_repetition_software/model/card.dart";

class ExplorerCardItem extends StatelessWidget {
  final Card card;

  const ExplorerCardItem({ required this.card, super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(child: Text('A')),
      title: Text(card.front),
      trailing: const Icon(Icons.more_vert),
      onTap: () => {},
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      tileColor: Theme.of(context).cardColor,
    );
  }
}