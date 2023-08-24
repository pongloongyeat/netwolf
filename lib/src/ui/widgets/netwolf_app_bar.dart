import 'package:flutter/material.dart';

class NetwolfAppBar extends StatelessWidget implements PreferredSizeWidget {
  const NetwolfAppBar({
    super.key,
    required this.title,
    this.bottom,
    this.actions,
  });

  final String title;
  final PreferredSizeWidget? bottom;
  final List<IconButton>? actions;

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0));

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(title),
      bottom: bottom,
    );
  }
}
