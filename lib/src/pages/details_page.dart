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

  final NetwolfResponseWithRelativeTimestamp response;

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
            content: response.response.url,
          ),
          SectionListItem(
            label: 'Method',
            content: response.response.method?.name.toUpperCase(),
          ),
          SectionListItem(
            label: 'Response code',
            content: response.response.responseCode?.toString(),
          ),
          SectionListItem(
            label: 'Timestamp',
            content: response.response.timeStamp.toIso8601String(),
          ),
          SectionListItem(
            label: 'Duration since app started',
            content: response.relativeTimestamp.toString(),
          ),
        ].joined(const SizedBox(height: 24)),
      ),
    );
  }

  Widget _buildRequestTab(BuildContext context) {
    final requestHeaders = response.response.requestHeaders ?? {};
    final requestBody = response.response.requestBody;

    if (requestHeaders.isEmpty && requestBody == null) {
      return const Center(
        child: Text('Empty request'),
      );
    }

    return SingleChildScrollView(
      padding: kDefaultPadding,
      child: Column(
        children: [
          Column(
            children: requestHeaders.entries
                .map(
                  (entry) => SectionListItem(
                    label: entry.key,
                    content: '${entry.value}',
                  ),
                )
                .toList()
                .joined(const SizedBox(height: 24)),
          ),
          if (requestBody != null)
            Container(
              margin: const EdgeInsets.symmetric(vertical: 32),
              color: Colors.grey,
              width: double.infinity,
              height: 1,
            ),
          if (requestBody != null)
            CopyableText(
              source: _tryParseAsPrettyJson(requestBody) ?? '$requestBody',
            ),
        ],
      ),
    );
  }

  Widget _buildResponseTab(BuildContext context) {
    final responseHeaders = response.response.responseHeaders ?? {};
    final responseBody = response.response.responseBody;

    if (responseHeaders.isEmpty && responseBody == null) {
      return const Center(
        child: Text('Empty response'),
      );
    }

    return SingleChildScrollView(
      padding: kDefaultPadding,
      child: Column(
        children: [
          Column(
            children: responseHeaders.entries
                .map(
                  (entry) => SectionListItem(
                    label: entry.key,
                    content: '${entry.value}',
                  ),
                )
                .toList()
                .joined(const SizedBox(height: 24)),
          ),
          if (responseBody != null)
            Container(
              margin: const EdgeInsets.symmetric(vertical: 32),
              color: Colors.grey,
              width: double.infinity,
              height: 1,
            ),
          if (responseBody != null)
            CopyableText(
              source: _tryParseAsPrettyJson(responseBody) ?? '$responseBody',
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
