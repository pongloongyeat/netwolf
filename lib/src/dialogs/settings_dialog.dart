import 'package:flutter/material.dart';
import 'package:netwolf/netwolf.dart';
import 'package:netwolf/src/constants.dart';
import 'package:netwolf/src/dialogs/dialogs.dart';
import 'package:netwolf/src/widgets/widgets.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingsDialog extends StatefulWidget {
  const SettingsDialog(this.controller, {super.key});

  final NetwolfController controller;

  @override
  State<SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  @override
  Widget build(BuildContext context) {
    return BaseDialog(
      title: 'Settings',
      content: _buildContent(context),
      buttons: _buildButtons(),
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
        value: widget.controller.logging,
        onChanged: (value) {
          widget.controller.setLogging(value);
          setState(() {});
        },
      ),
    );
  }

  Widget _buildButtons() {
    return ElevatedButton(
      onPressed: () {
        widget.controller.clearResponses();
        NetwolfRouter.of(context).dismiss();
      },
      style: (Theme.of(context).elevatedButtonTheme.style ??
              ElevatedButton.styleFrom())
          .copyWith(
        backgroundColor: MaterialStateProperty.all(kDestructiveColor),
      ),
      child: const Text('Clear data'),
    );
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
