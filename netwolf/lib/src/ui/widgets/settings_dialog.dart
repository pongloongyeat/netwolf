import 'package:flutter/material.dart';
import 'package:netwolf/src/core/constants.dart';
import 'package:netwolf/src/core/netwolf_controller.dart';
import 'package:netwolf/src/ui/widgets/base_dialog.dart';

class SettingsDialog extends StatefulWidget {
  const SettingsDialog({
    super.key,
    required this.onClearDataPressed,
  });

  final VoidCallback onClearDataPressed;

  @override
  State<SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  @override
  Widget build(BuildContext context) {
    return BaseDialog(
      title: 'Settings',
      content: _buildContent(context),
      buttons: _buildButtons(context),
      footer: _buildFooter(),
    );
  }

  Widget _buildRow(
    BuildContext context, {
    required String label,
    required Widget child,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        child,
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    return _buildRow(
      context,
      label: 'Logging',
      child: Switch.adaptive(
        value: NetwolfController.instance.logging,
        onChanged: (value) {
          setState(() {
            NetwolfController.instance.setLogging(value);
          });
        },
      ),
    );
  }

  List<ElevatedButton> _buildButtons(BuildContext context) {
    return [
      ElevatedButton(
        onPressed: _onClearDataPressed,
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

  void _onClearDataPressed() {
    NetwolfController.instance.clearAll().then((_) {
      widget.onClearDataPressed();
      Navigator.of(context).pop();
    });
  }
}
