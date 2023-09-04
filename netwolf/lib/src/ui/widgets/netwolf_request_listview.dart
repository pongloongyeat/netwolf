import 'package:flutter/material.dart';
import 'package:netwolf/src/core/constants.dart';
import 'package:netwolf/src/core/enums.dart';
import 'package:netwolf/src/core/extensions.dart';
import 'package:netwolf/src/ui/pages/netwolf_details_page.dart';
import 'package:netwolf_core/netwolf_core.dart';

class NetwolfRequestListView extends StatelessWidget {
  const NetwolfRequestListView({
    super.key,
    required this.searchTerm,
    this.method,
    this.status,
    required this.requests,
  });

  final String searchTerm;
  final HttpRequestMethod? method;
  final HttpResponseStatus? status;
  final List<NetwolfRequestData> requests;

  @override
  Widget build(BuildContext context) {
    final requests = this.requests;
    final filteredRequests = requests.reversed.toList();
    final searchTerm = this.searchTerm;
    if (searchTerm.isNotEmpty) {
      filteredRequests.retainWhere(
        (element) => element.uri
            .toString()
            .toLowerCase()
            .contains(searchTerm.toLowerCase()),
      );
    }

    final method = this.method;
    if (method != null) {
      filteredRequests.retainWhere((element) => element.method == method);
    }

    final status = this.status;
    if (status != null) {
      filteredRequests.retainWhere(
        (element) =>
            HttpResponseStatus.fromStatusCode(element.statusCode) == status,
      );
    }

    final showing = filteredRequests.length;
    final total = requests.length;

    return Column(
      children: [
        Text('Showing $showing of $total responses'),
        const SizedBox(height: 8),
        Expanded(
          child: filteredRequests.isEmpty
              ? _buildEmptyListing()
              : _buildListing(filteredRequests),
        ),
      ],
    );
  }

  Widget _buildEmptyListing() {
    final searchTerm = this.searchTerm;
    final method = this.method;
    final status = this.status;
    final hasFilters =
        searchTerm.isNotEmpty || method != null || status != null;

    return Center(
      child: Column(
        children: [
          const Spacer(flex: 2),
          Text(
            hasFilters
                ? [
                    'No requests found with the following filters:\n\n',
                    if (searchTerm.isNotEmpty) 'Search term: "$searchTerm"\n',
                    if (method != null)
                      'Request method: ${method.name.toUpperCase()}\n',
                    if (status != null)
                      'Response status: ${status.name.toUpperCase()}\n',
                  ].join()
                : 'No requests',
            textAlign: TextAlign.center,
          ),
          const Spacer(flex: 3),
        ],
      ),
    );
  }

  Widget _buildListing(List<NetwolfRequestData> filteredRequests) {
    return ListView.separated(
      itemCount: filteredRequests.length,
      itemBuilder: (_, index) => _NetwolfRequestListViewItem(
        filteredRequests[index],
      ),
      separatorBuilder: (context, index) => const Divider(),
    );
  }
}

class _NetwolfRequestListViewItem extends StatelessWidget {
  _NetwolfRequestListViewItem(this.request) : super(key: ValueKey(request.id));

  final NetwolfRequestData request;

  @override
  Widget build(BuildContext context) {
    final requestId = request.id;
    final method = request.method;
    final statusCode = request.statusCode;
    final url = request.uri;
    final startTime = request.startTime;
    final responseTime = request.responseTime;
    final completed = request.completed;

    return Column(
      children: [
        InkWell(
          onTap: requestId != null
              ? () => _navigateToDetails(context, requestId: requestId)
              : null,
          child: Padding(
            padding: kDefaultPadding.copyWith(top: 12, bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            method.name.toUpperCase(),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            url.toString(),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    _StatusChip(statusCode, completed: completed),
                  ],
                ),
                const SizedBox(height: 8),
                _NetwolfRequestListViewItemFooter(
                  startTime: startTime,
                  responseTime: responseTime,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _navigateToDetails(BuildContext context, {required int requestId}) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => NetwolfDetailsPage(requestId),
      ),
    );
  }
}

class _NetwolfRequestListViewItemFooter extends StatelessWidget {
  const _NetwolfRequestListViewItemFooter({
    required this.startTime,
    required this.responseTime,
  });

  final DateTime startTime;
  final Duration? responseTime;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          startTime.toString(),
          style: Theme.of(context).textTheme.bodySmall,
        ),
        if (responseTime != null)
          Text(
            '${responseTime!.inMilliseconds} ms',
            style: Theme.of(context).textTheme.bodySmall,
          ),
      ],
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip(
    this.statusCode, {
    required this.completed,
  });

  final int? statusCode;
  final bool completed;

  @override
  Widget build(BuildContext context) {
    final status = HttpResponseStatus.fromStatusCode(statusCode);
    final code = statusCode == null ? 'Unknown' : '$statusCode';

    return Container(
      decoration: BoxDecoration(
        color: status.toColor(),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 6,
      ),
      child: Text(
        completed ? code : 'Pending',
        style: Theme.of(context)
            .textTheme
            .bodySmall
            ?.copyWith(color: Colors.white),
      ),
    );
  }
}
