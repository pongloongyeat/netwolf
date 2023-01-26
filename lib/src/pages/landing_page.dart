import 'package:flutter/material.dart';
import 'package:netwolf/netwolf.dart';
import 'package:netwolf/src/constants.dart';
import 'package:netwolf/src/dialogs/dialogs.dart';
import 'package:netwolf/src/widgets/widgets.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NetwolfAppBar(
        title: kPackageName,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => NetwolfRouter.of(context).present(
              (context) => StatefulBuilder(
                builder: (context, setState) {
                  return SettingsDialog(
                    logging: NetwolfController.instance.logging,
                    onClearDataPressed:
                        NetwolfController.instance.clearResponses,
                    onLoggingChanged: (value) {
                      if (value) {
                        NetwolfController.instance.enableLogging();
                      } else {
                        NetwolfController.instance.disableLogging();
                      }

                      setState(() {});
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: kDefaultPadding.copyWith(left: 0, right: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: kDefaultPadding.copyWith(top: 0, bottom: 0),
            child: const NetwolfSearchBar(),
          ),
          const SizedBox(height: 16),
          const Expanded(child: NetwolfRequestListView()),
        ],
      ),
    );
  }
}
