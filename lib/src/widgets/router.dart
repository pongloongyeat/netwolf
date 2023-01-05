import 'package:flutter/material.dart';
import 'package:netwolf/netwolf.dart';
import 'package:netwolf/src/constants.dart';

/// To mimic typical [Navigator] scenarios because the [NetwolfWidget] is not
/// meant to wrap an existing [Navigator].
class NetwolfRouter extends StatefulWidget {
  const NetwolfRouter({
    super.key,
    required this.initialPage,
  });

  final Widget initialPage;

  static NetwolfRouterState of(
    BuildContext context, {
    bool useRootRouter = false,
  }) {
    if (useRootRouter) {
      return context.findRootAncestorStateOfType<NetwolfRouterState>()!;
    } else {
      return context.findAncestorStateOfType<NetwolfRouterState>()!;
    }
  }

  @override
  State<NetwolfRouter> createState() => NetwolfRouterState();
}

class NetwolfRouterState extends State<NetwolfRouter> {
  final _pageStack = <Widget>[];
  final _presentedStack = <Widget>[];
  final _controller = PageController();

  @override
  void initState() {
    super.initState();
    _pageStack.add(widget.initialPage);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageView(
          controller: _controller,
          physics: const NeverScrollableScrollPhysics(),
          children: _pageStack,
        ),
        ..._presentedStack,
      ],
    );
  }

  bool canPop() => _pageStack.length > 1;

  void push(Widget widget) {
    setState(() {
      _pageStack.add(widget);
      _controller.animateToPage(
        _pageStack.length - 1,
        duration: kAnimationDuration,
        curve: kAnimationCurveIn,
      );
    });
  }

  void pop() {
    setState(() {
      _controller.animateToPage(
        _pageStack.length - 2,
        duration: kAnimationDuration,
        curve: kAnimationCurveOut,
      );
      _pageStack.removeLast();
    });
  }

  void present(Widget widget) {
    setState(() {
      _presentedStack.add(_OverlayWidget(child: widget));
    });
  }

  void dismiss() {
    setState(_presentedStack.removeLast);
  }
}

class _OverlayWidget extends StatelessWidget {
  const _OverlayWidget({required this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: NetwolfRouter.of(context).dismiss,
          child: const SizedBox.expand(child: ColoredBox(color: kOverlayColor)),
        ),
        child ?? Container(),
      ],
    );
  }
}
