import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
    final content = this.content;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.copy),
              visualDensity: VisualDensity.compact,
              onPressed: content != null
                  ? () => Clipboard.setData(ClipboardData(text: content))
                      .then((_) => _showCopiedSnackbar(context))
                  : null,
            ),
          ],
        ),
        const SizedBox(height: 4),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SelectableText(
              content ?? '',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ),
      ],
    );
  }

  void _showCopiedSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Copied to clipboard')),
    );
  }
}
