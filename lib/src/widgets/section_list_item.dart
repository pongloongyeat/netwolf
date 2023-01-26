import 'package:flutter/material.dart';

class SectionListItem extends StatelessWidget {
  const SectionListItem({
    super.key,
    required this.label,
    this.content,
  });

  final String label;
  final String? content;

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          '[$label]',
          style: style.copyWith(color: Colors.grey[600]),
        ),
        const SizedBox(height: 4),
        Text(content ?? '?', style: style),
      ],
    );
  }
}
