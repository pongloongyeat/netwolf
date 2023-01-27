import 'package:flutter/material.dart';
import 'package:netwolf/src/constants.dart';
import 'package:netwolf/src/dialogs/dialogs.dart';

class SettingsDialog extends StatelessWidget {
  const SettingsDialog({
    super.key,
    required this.logging,
    required this.onClearDataPressed,
    required this.onLoggingChanged,
  });

  final bool logging;
  final VoidCallback onClearDataPressed;
  final ValueChanged<bool> onLoggingChanged;

  @override
  Widget build(BuildContext context) {
    return BaseDialog(
      title: 'Settings',
      content: _buildContent(context),
      buttons: _buildButtons(context),
      footer: _buildFooter(),
    );
  }

  Widget _buildRow(String label, Widget child) {
    return Row(
      children: [
        Expanded(child: Text(label, style: kLabelTextStyle)),
        child,
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    return _buildRow(
      'Logging',
      Switch.adaptive(
        value: logging,
        onChanged: onLoggingChanged,
      ),
    );
  }

  List<ElevatedButton> _buildButtons(BuildContext context) {
    return [
      ElevatedButton(
        onPressed: () {
          onClearDataPressed();
          Navigator.of(context).pop();
        },
        style: (Theme.of(context).elevatedButtonTheme.style ??
                ElevatedButton.styleFrom())
            .copyWith(
          backgroundColor: MaterialStateProperty.all(kDestructiveColor),
        ),
        child: const Text('Clear data'),
      ),
    ];
  }

  Widget _buildFooter() {
    return const Center(
      child: Text(
        '$kPackageName $kVersionName',
        style: TextStyle(fontWeight: FontWeight.w300),
      ),
    );
  }
}
