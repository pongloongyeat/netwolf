import 'package:flutter/material.dart';

class ExpandableSection extends StatefulWidget {
  const ExpandableSection({
    super.key,
    this.expand = false,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.linear,
    this.axisAlignment = 1,
    required this.child,
  });

  final bool expand;
  final Duration duration;
  final Curve curve;
  final double axisAlignment;
  final Widget child;

  @override
  State<ExpandableSection> createState() => _ExpandableSectionState();
}

class _ExpandableSectionState extends State<ExpandableSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _expandController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _expandController = AnimationController(
      vsync: this,
      value: widget.expand ? 1 : 0,
      duration: widget.duration,
    );
    _animation = CurvedAnimation(
      parent: _expandController,
      curve: widget.curve,
    );

    _runExpandCheck();
  }

  void _runExpandCheck() {
    if (widget.expand) {
      _expandController.forward();
    } else {
      _expandController.reverse();
    }
  }

  @override
  void didUpdateWidget(ExpandableSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    _runExpandCheck();
  }

  @override
  void dispose() {
    _expandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      axisAlignment: widget.axisAlignment,
      sizeFactor: _animation,
      child: widget.child,
    );
  }
}
