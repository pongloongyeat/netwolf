import 'package:flutter/material.dart';
import 'package:netwolf/src/core/constants.dart';
import 'package:netwolf/src/ui/widgets/netwolf_app_bar.dart';
import 'package:netwolf/src/ui/widgets/netwolf_request_listview.dart';
import 'package:netwolf/src/ui/widgets/netwolf_search_bar.dart';
import 'package:netwolf/src/ui/widgets/settings_dialog.dart';

class NetwolfLandingPage extends StatelessWidget {
  const NetwolfLandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NetwolfAppBar(
        title: kPackageName,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => showDialog<void>(
              context: context,
              builder: (_) => const SettingsDialog(),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(
          top: kDefaultPadding.top,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: kDefaultPadding.copyWith(top: 0, bottom: 0),
              child: const NetwolfSearchBar(),
            ),
            const SizedBox(height: 16),
            const Expanded(
              child: NetwolfRequestListView(),
            ),
          ],
        ),
      ),
    );
  }
}
