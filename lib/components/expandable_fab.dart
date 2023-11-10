import 'package:flutter/material.dart';

class ExpandableFab extends StatefulWidget {
  const ExpandableFab({
    super.key,
    this.initialOpen,
    required this.children,
  });

  final bool? initialOpen;
  final List<Widget> children;

  @override
  State<StatefulWidget> createState() => _ExpandableFabState();
}

class _ExpandableFabState extends State<ExpandableFab> with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late final AnimationController _controller;
  late final Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initialOpen ?? false;
    _controller = AnimationController(
      value: _isExpanded ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      curve: Curves.fastOutSlowIn,
      reverseCurve: Curves.easeOutQuad,
      parent: _controller,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void toggle() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        alignment: Alignment.bottomRight,
        clipBehavior: Clip.none,
        children: [
          for (final (index, item) in widget.children.indexed)
            AnimatedBuilder(
              animation: _expandAnimation,
              builder: (BuildContext context, Widget? child) {
                return Positioned(
                  right: 4.0,
                  bottom: (index == 0 ? 6 : 0) + 75 * _expandAnimation.value * (index + 1),
                  child: item,
                );
              },
              child: FadeTransition(
                opacity: _expandAnimation,
                child: item,
              ),
            ),
          FloatingActionButton(
            onPressed: toggle,
            backgroundColor: Theme.of(context).colorScheme.surface,
            child: Icon(Icons.add, color: Theme.of(context).colorScheme.primary),
          ),
        ],
      ),
    );
  }
}
