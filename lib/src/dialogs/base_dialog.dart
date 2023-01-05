import 'package:flutter/material.dart';

class BaseDialog extends StatelessWidget {
  const BaseDialog({
    super.key,
    required this.title,
    required this.content,
    this.buttons,
    this.footer,
  });

  final String title;
  final Widget content;
  final Widget? buttons;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            content,
            if (buttons != null) const SizedBox(height: 16),
            if (buttons != null) buttons!,
            if (footer != null) const SizedBox(height: 16),
            if (footer != null) footer!
          ],
        ),
      ),
    );
  }
}
