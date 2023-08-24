import 'package:flutter/material.dart';
import 'package:netwolf/src/constants.dart';
import 'package:netwolf/src/ui/widgets/netwolf_app_bar.dart';
import 'package:netwolf/src/ui/widgets/netwolf_request_listview.dart';
import 'package:netwolf/src/ui/widgets/netwolf_search_bar.dart';

class NetwolfLandingPage extends StatelessWidget {
  const NetwolfLandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NetwolfAppBar(
        title: kPackageName,
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
