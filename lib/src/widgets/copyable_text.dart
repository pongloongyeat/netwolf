import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CopyableText extends StatelessWidget {
  const CopyableText({
    super.key,
    required this.source,
  });

  final String source;

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(fontSize: 16);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onLongPress: () {
        Clipboard.setData(ClipboardData(text: source)).then(
          (value) => ScaffoldMessenger.maybeOf(context)?.showSnackBar(
            const SnackBar(
              behavior: SnackBarBehavior.floating,
              padding: EdgeInsets.all(16),
              content: Text('Copied to clipboard'),
            ),
          ),
        );
      },
      child: Text(
        source,
        style: style,
      ),
    );
  }
}
