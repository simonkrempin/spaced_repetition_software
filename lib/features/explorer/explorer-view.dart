import 'package:flutter/material.dart';
import 'package:spaced_repetition_software/features/explorer/components/card.dart';

class ExplorerView extends StatelessWidget {
  const ExplorerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: ListView.separated(
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(height: 8);
        },
        itemBuilder: (BuildContext context, int index) => const ExplorerCard(),
        itemCount: 2,
      ),
    );
  }
}
