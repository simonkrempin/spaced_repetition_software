import "package:flutter/material.dart";

class DividerWithText extends StatelessWidget {
  final String text;

  const DividerWithText({ required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Divider(),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(text),
        ),
        const Expanded(
          child: Divider(),
        ),
      ],
    );
  }
}
