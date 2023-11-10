import 'package:flutter/material.dart';
import 'package:spaced_repetition_software/model/deck.dart';

class ExplorerDeckItem extends StatelessWidget {
  final Deck deck;

  const ExplorerDeckItem({ required this.deck, super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(child: Text('A')),
      title: Text(deck.name),
      trailing: const Icon(Icons.more_vert),
      onTap: () => {},
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      tileColor: Theme.of(context).cardColor,
    );
  }
}
