import 'package:flutter/material.dart';
import 'package:netwolf/src/extensions.dart';
import 'package:netwolf/src/widget.dart';
import 'package:netwolf/src/widgets/widgets.dart';

enum _RequestDetailsTab { info, request, response }

class ResponseDetails extends StatelessWidget {
  const ResponseDetails({
    super.key,
    required this.controller,
    required this.response,
  });

  final NetwolfController controller;
  final NetwolfResponseWithRelativeTimestamp response;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _RequestDetailsTab.values.length,
      child: Scaffold(
        appBar: NetwolfAppBar(
          title: 'Request details',
          controller: controller,
          bottom: TabBar(
            tabs: _RequestDetailsTab.values
                .map((e) => Tab(text: e.name.toTitleCase()))
                .toList(),
          ),
        ),
        body: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return TabBarView(
      children:
          _RequestDetailsTab.values.map((e) => _buildTab(context, e)).toList(),
    );
  }

  Widget _buildTab(BuildContext context, _RequestDetailsTab tab) {
    return Container();
  }
}
