import 'package:flutter/material.dart';
import 'package:netwolf/src/constants.dart';
import 'package:netwolf/src/dialogs/dialogs.dart';
import 'package:netwolf/src/widgets/widgets.dart';
import 'package:package_info_plus/package_info_plus.dart';

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
          NetwolfRouter.of(context).dismiss();
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
    return FutureBuilder<PackageInfo?>(
      future: PackageInfo.fromPlatform(),
      builder: (context, snapshot) {
        final data = snapshot.data;

        if (data != null) {
          final version = data.version;
          final buildNumber = data.buildNumber;

          return Center(
            child: Text(
              '$kPackageName $version ($buildNumber)',
              style: const TextStyle(fontWeight: FontWeight.w300),
            ),
          );
        }

        return Container();
      },
    );
  }
}
