import 'package:flutter/material.dart';
import 'package:netwolf/src/constants.dart';
import 'package:netwolf/src/core/netwolf_controller.dart';
import 'package:netwolf/src/enums.dart';
import 'package:netwolf/src/extensions.dart';
import 'package:netwolf/src/models/netwolf_request.dart';
import 'package:netwolf/src/ui/pages/netwolf_details_page.dart';
import 'package:notification_dispatcher/notification_dispatcher.dart';

class NetwolfRequestListView extends StatefulWidget {
  const NetwolfRequestListView({super.key});

  @override
  State<NetwolfRequestListView> createState() => _NetwolfRequestListViewState();
}

class _NetwolfRequestListViewState extends State<NetwolfRequestListView> {
  String? _searchTerm;
  List<NetwolfRequest> _requests = [];

  @override
  void initState() {
    super.initState();
    NetwolfController.instance.getRequests().then((value) {
      _requests = value.data ?? _requests;
      if (mounted) setState(() {});
    });

    NotificationDispatcher.instance.addObserver(
      this,
      name: NotificationName.search.name,
      callback: _onSearch,
    );
  }

  @override
  void dispose() {
    NotificationDispatcher.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final requests = _requests.toList();
    final searchTerm = _searchTerm ?? '';
    if (searchTerm.isNotEmpty) {
      requests.retainWhere(
        (element) => element.uri
            .toString()
            .toLowerCase()
            .contains(searchTerm.toLowerCase()),
      );
    }

    return ListView.separated(
      itemCount: requests.length,
      itemBuilder: (_, index) => _NetwolfRequestListViewItem(requests[index]),
      separatorBuilder: (context, index) => const Divider(),
    );
  }

  void _onSearch(NotificationMessage message) {
    final searchTerm = message.info?[NotificationKey.searchTerm.name];

    if (searchTerm is String) {
      setState(() => _searchTerm = searchTerm);
    }
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
