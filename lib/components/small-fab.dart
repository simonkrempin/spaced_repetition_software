import 'package:flutter/material.dart';

class SmallFab extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const SmallFab({ required this.icon, required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.small(
      onPressed: onPressed,
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Icon(icon, color: Theme.of(context).colorScheme.primary),
    );
  }
}
