import 'package:flutter/material.dart';

class ExplorerCard extends StatelessWidget {
  const ExplorerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(child: Text('A')),
      title: const Text("Bürgerlichesgesetzbuch"),
      trailing: const Icon(Icons.more_vert),
      onTap: () => {},
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      tileColor: Theme.of(context).cardColor,
    );
  }
}
