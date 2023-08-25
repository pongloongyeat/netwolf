import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:netwolf/src/constants.dart';
import 'package:netwolf/src/core/netwolf_controller.dart';
import 'package:netwolf/src/core/typedefs.dart';
import 'package:netwolf/src/extensions.dart';
import 'package:netwolf/src/models/netwolf_request.dart';
import 'package:netwolf/src/models/result.dart';
import 'package:netwolf/src/ui/widgets/netwolf_app_bar.dart';
import 'package:netwolf/src/ui/widgets/section_list_item.dart';

enum _RequestDetailsTab { info, request, response }

class NetwolfDetailsPage extends StatelessWidget {
  const NetwolfDetailsPage(
    this.requestId, {
    super.key,
  });

  final Id requestId;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _RequestDetailsTab.values.length,
      child: Scaffold(
        appBar: _buildAppBar(),
        body: FutureBuilder<Result<NetwolfRequest, Exception>>(
          future: NetwolfController.instance.getRequestById(requestId),
          builder: (context, snapshot) {
            final result = snapshot.data;
            if (result == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final data = result.data;
            final error = result.error;
            if (data == null || result.hasError) {
              return Center(
                child: Text('Something went wrong\n${error ?? ''}'),
              );
            }

            return _buildBody(context, request: data);
          },
        ),
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

  Widget _buildBody(
    BuildContext context, {
    required NetwolfRequest request,
  }) {
    return TabBarView(
      children: _RequestDetailsTab.values
          .map((e) => _buildTab(context, e, request))
          .toList(),
    );
  }

  Widget _buildTab(
    BuildContext context,
    _RequestDetailsTab tab,
    NetwolfRequest request,
  ) {
    switch (tab) {
      case _RequestDetailsTab.info:
        return _buildInfoTab(context, request: request);
      case _RequestDetailsTab.request:
        return _buildRequestTab(context, request: request);
      case _RequestDetailsTab.response:
        return _buildResponseTab(context, request: request);
    }
  }

  Widget _buildInfoTab(
    BuildContext context, {
    required NetwolfRequest request,
  }) {
    return SingleChildScrollView(
      padding: kDefaultPadding,
      child: Column(
        children: [
          SectionListItem(
            label: 'URL',
            content: request.uri.toString(),
          ),
          SectionListItem(
            label: 'Method',
            content: request.method.name.toUpperCase(),
          ),
          SectionListItem(
            label: 'Status code',
            content: request.statusCode?.toString(),
          ),
          SectionListItem(
            label: 'Timestamp',
            content: request.startTime.toIso8601String(),
          ),
        ].joined(const SizedBox(height: 8)),
      ),
    );
  }

  Widget _buildRequestTab(
    BuildContext context, {
    required NetwolfRequest request,
  }) {
    final requestHeaders = request.requestHeaders ?? {};
    final requestBody = request.requestBody;

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
            content: _tryParseHeadersAsPrettyJson(requestHeaders),
          ),
          const SizedBox(height: 16),
          if (requestBody != null)
            SectionListItem(
              label: 'Request body',
              content: _tryParseBodyAsPrettyJson(requestBody) ?? requestBody,
            ),
        ],
      ),
    );
  }

  Widget _buildResponseTab(
    BuildContext context, {
    required NetwolfRequest request,
  }) {
    final responseHeaders = request.responseHeaders ?? {};
    final responseBody = request.responseBody;

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
            content: _tryParseHeadersAsPrettyJson(responseHeaders),
          ),
          const SizedBox(height: 16),
          if (responseBody != null)
            SectionListItem(
              label: 'Response body',
              content: _tryParseBodyAsPrettyJson(responseBody) ?? responseBody,
            ),
        ],
      ),
    );
  }

  String? _tryParseHeadersAsPrettyJson(Map<String, dynamic> headers) {
    try {
      return JsonEncoder.withIndent(' ' * 2).convert(headers);
    } catch (e) {
      return null;
    }
  }

  String? _tryParseBodyAsPrettyJson(String body) {
    try {
      return JsonEncoder.withIndent(' ' * 2).convert(jsonDecode(body));
    } catch (e) {
      return null;
    }
  }
}
