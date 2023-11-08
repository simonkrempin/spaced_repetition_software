import 'package:flutter/material.dart';

class CardsView extends StatelessWidget {
  const CardsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: ListView.separated(
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(height: 8);
        },
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            leading: const CircleAvatar(child: Text('A')),
            title: const Text("Bürgerlichesgesetzbuch"),
            trailing: const Icon(Icons.more_vert),
            onTap: () => {},
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            tileColor: Theme.of(context).cardColor,
          );
        },
        itemCount: 2,
      ),
    );
  }
}
