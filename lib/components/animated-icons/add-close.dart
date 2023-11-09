import 'dart:math';
import 'package:flutter/material.dart';

class AddCloseIcon extends StatefulWidget {
  const AddCloseIcon({super.key});

  @override
  State<StatefulWidget> createState() => _AddCloseIconState();
}

class _AddCloseIconState extends State<AddCloseIcon> with SingleTickerProviderStateMixin {
  late AnimationController animatedController;
  double _angle = 0;

  @override
  void initState() {
    animatedController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    animatedController.addListener(() {
      setState(() {
        _angle = animatedController.value * 45 / 360 * pi * 2;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkResponse(
        onTap: () {
          if (animatedController.status == AnimationStatus.completed) {
            animatedController.reverse();
          } else if (animatedController.status == AnimationStatus.dismissed) {
            animatedController.forward()
          }
        },
        child: Transform.rotate(
          angle: _angle,
          child: const Icon(
            Icons.add,
            size: 50,
          ),
        ),
      ),
    );
  }
}
