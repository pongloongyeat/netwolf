import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:netwolf/netwolf.dart';
import 'package:netwolf/src/constants.dart';
import 'package:netwolf/src/extensions.dart';
import 'package:netwolf/src/widgets/widgets.dart';

enum _RequestDetailsTab { info, request, response }

class DetailsPage extends StatelessWidget {
  const DetailsPage({
    super.key,
    required this.response,
  });

  final NetwolfResponse response;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _RequestDetailsTab.values.length,
      child: Scaffold(
        appBar: _buildAppBar(),
        body: _buildBody(context),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return NetwolfAppBar(
      title: 'Request details',
      bottom: TabBar(
        tabs: _RequestDetailsTab.values
            .map((e) => Tab(text: e.name.toTitleCase()))
            .toList(),
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
    switch (tab) {
      case _RequestDetailsTab.info:
        return _buildInfoTab(context);
      case _RequestDetailsTab.request:
        return _buildRequestTab(context);
      case _RequestDetailsTab.response:
        return _buildResponseTab(context);
    }
  }

  Widget _buildInfoTab(BuildContext context) {
    return SingleChildScrollView(
      padding: kDefaultPadding,
      child: Column(
        children: [
          SectionListItem(
            label: 'URL',
            content: response.url,
          ),
          SectionListItem(
            label: 'Method',
            content: response.method?.name.toUpperCase(),
          ),
          SectionListItem(
            label: 'Response code',
            content: response.responseCode?.toString(),
          ),
          SectionListItem(
            label: 'Timestamp',
            content: response.startTime.toIso8601String(),
          ),
        ].joined(const SizedBox(height: 8)),
      ),
    );
  }

  Widget _buildRequestTab(BuildContext context) {
    final requestHeaders = response.requestHeaders ?? {};
    final requestBody = response.requestBody;

    if (requestHeaders.isEmpty && requestBody == null) {
      return const Center(
        child: Text('Empty request'),
      );
    }

    return SingleChildScrollView(
      padding: kDefaultPadding,
      child: Column(
        children: [
          SectionListItem(
            label: 'Headers',
            content: _tryParseAsPrettyJson(requestHeaders),
          ),
          const SizedBox(height: 16),
          if (requestBody != null)
            SectionListItem(
              label: 'Request body',
              content: _tryParseAsPrettyJson(requestBody) ?? '$requestBody',
            ),
        ],
      ),
    );
  }

  Widget _buildResponseTab(BuildContext context) {
    final responseHeaders = response.responseHeaders ?? {};
    final responseBody = response.responseBody;

    if (responseHeaders.isEmpty && responseBody == null) {
      return const Center(
        child: Text('Empty response'),
      );
    }

    return SingleChildScrollView(
      padding: kDefaultPadding,
      child: Column(
        children: [
          SectionListItem(
            label: 'Headers',
            content: _tryParseAsPrettyJson(responseHeaders),
          ),
          const SizedBox(height: 16),
          if (responseBody != null)
            SectionListItem(
              label: 'Response body',
              content: _tryParseAsPrettyJson(responseBody) ?? '$responseBody',
            ),
        ],
      ),
    );
  }

  String? _tryParseAsPrettyJson(dynamic source) {
    try {
      return JsonEncoder.withIndent(' ' * 2).convert(source);
    } catch (e) {
      return null;
    }
  }
}
