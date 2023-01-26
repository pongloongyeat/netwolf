import 'package:flutter/material.dart';
import 'package:netwolf/src/extensions.dart';

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
  final List<ElevatedButton>? buttons;
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
            if (buttons != null) _buildButtons(buttons!),
            if (footer != null) const SizedBox(height: 16),
            if (footer != null) footer!
          ],
        ),
      ),
    );
  }

  Widget _buildButtons(List<ElevatedButton> buttons) {
    if (buttons.length == 1) return buttons.first;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: buttons
          .map((e) => Flexible(child: e))
          .toList()
          .joined(const SizedBox(width: 8)),
    );
  }
}
