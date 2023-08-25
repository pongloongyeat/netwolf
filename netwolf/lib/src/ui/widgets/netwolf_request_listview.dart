import 'package:flutter/material.dart';
import 'package:netwolf/src/constants.dart';
import 'package:netwolf/src/controller.dart';
import 'package:netwolf/src/enums.dart';
import 'package:netwolf/src/extensions.dart';
import 'package:netwolf/src/ui/pages/netwolf_details_page.dart';
import 'package:netwolf_core/netwolf_core.dart';
import 'package:notification_dispatcher/notification_dispatcher.dart';

class NetwolfRequestListView extends StatefulWidget {
  const NetwolfRequestListView({super.key});

  @override
  State<NetwolfRequestListView> createState() => _NetwolfRequestListViewState();
}

class _NetwolfRequestListViewState extends State<NetwolfRequestListView> {
  String? _searchTerm;
  HttpRequestMethod? _method;
  HttpResponseStatus? _status;

  List<NetwolfRequest> _requests = [];

  @override
  void initState() {
    super.initState();

    _getRequests();
    NotificationDispatcher.instance
      ..addObserver(
        this,
        name: NotificationName.refetchRequests.name,
        callback: _onRefetchRequests,
      )
      ..addObserver(
        this,
        name: NotificationName.search.name,
        callback: _onSearch,
      )
      ..addObserver(
        this,
        name: NotificationName.updateFilters.name,
        callback: _onUpdateFilters,
      )
      ..addObserver(
        this,
        name: NotificationName.clearFilters.name,
        callback: _onClearFilters,
      );
  }

  @override
  void dispose() {
    NotificationDispatcher.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final requests = _requests;
    final filteredRequests = requests.reversed.toList();
    final searchTerm = _searchTerm ?? '';
    if (searchTerm.isNotEmpty) {
      filteredRequests.retainWhere(
        (element) => element.uri
            .toString()
            .toLowerCase()
            .contains(searchTerm.toLowerCase()),
      );
    }

    if (_method != null) {
      filteredRequests.retainWhere((element) => element.method == _method);
    }

    if (_status != null) {
      filteredRequests.retainWhere(
        (element) =>
            HttpResponseStatus.fromResponseCode(element.statusCode) == _status,
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
    final searchTerm = _searchTerm ?? '';
    final hasFilters = searchTerm.isNotEmpty;

    return Center(
      child: Column(
        children: [
          const Spacer(flex: 2),
          Text(
            hasFilters
                ? [
                    'No requests found with the following filters:\n\n',
                    if (searchTerm.isNotEmpty) 'Search term: "$searchTerm"\n'
                    // 'Request method: ${(method?.name ?? '-').toUpperCase()}\n'
                    // 'Response status: ${(status?.name ?? '-').toUpperCase()}\n',
                  ].join()
                : 'No requests',
            textAlign: TextAlign.center,
          ),
          const Spacer(flex: 3),
        ],
      ),
    );
  }

  Widget _buildListing(List<NetwolfRequest> filteredRequests) {
    return ListView.separated(
      itemCount: filteredRequests.length,
      itemBuilder: (_, index) => _NetwolfRequestListViewItem(
        filteredRequests[index],
      ),
      separatorBuilder: (context, index) => const Divider(),
    );
  }

  void _getRequests() {
    NetwolfController.instance.getRequests().then((value) {
      _requests = value.data ?? _requests;
      if (mounted) setState(() {});
    });
  }

  void _onRefetchRequests(NotificationMessage _) {
    _getRequests();
  }

  void _onSearch(NotificationMessage message) {
    final searchTerm = message.info?[NotificationKey.searchTerm.name];

    if (searchTerm is String) {
      setState(() => _searchTerm = searchTerm);
    }
  }

  void _onUpdateFilters(NotificationMessage message) {
    final method = message.info?[NotificationKey.method.name];
    final status = message.info?[NotificationKey.status.name];

    setState(() {
      if (method is HttpRequestMethod?) _method = method;
      if (status is HttpResponseStatus?) _status = status;
    });
  }

  void _onClearFilters(NotificationMessage _) {
    setState(() {
      _method = null;
      _status = null;
    });
  }
}

class _NetwolfRequestListViewItem extends StatelessWidget {
  _NetwolfRequestListViewItem(this.request) : super(key: ValueKey(request.id));

  final NetwolfRequest request;

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
                    if (statusCode != null)
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

  final int statusCode;
  final bool completed;

  @override
  Widget build(BuildContext context) {
    final status = HttpResponseStatus.fromResponseCode(statusCode);

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
        completed ? '$statusCode' : 'Pending',
        style: Theme.of(context)
            .textTheme
            .bodySmall
            ?.copyWith(color: Colors.white),
      ),
    );
  }
}
