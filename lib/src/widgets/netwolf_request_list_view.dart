import 'package:flutter/material.dart';
import 'package:netwolf/netwolf.dart';
import 'package:netwolf/src/constants.dart';
import 'package:netwolf/src/enums.dart';
import 'package:netwolf/src/extensions.dart';
import 'package:netwolf/src/pages/pages.dart';
import 'package:notification_dispatcher/notification_dispatcher.dart';

typedef EmptyListingTextBuilder = String Function(
  String searchTerm,
  HttpRequestMethod? method,
  HttpResponseStatus? status,
);

class NetwolfRequestListView extends StatefulWidget {
  const NetwolfRequestListView({super.key});

  @override
  State<NetwolfRequestListView> createState() => _NetwolfRequestListViewState();
}

class _NetwolfRequestListViewState extends State<NetwolfRequestListView> {
  String? _searchTerm;
  HttpRequestMethod? _method;
  HttpResponseStatus? _status;

  @override
  void initState() {
    super.initState();
    NotificationDispatcher.instance
      ..addObserver(
        this,
        name: NotificationName.search.name,
        callback: _search,
      )
      ..addObserver(
        this,
        name: NotificationName.clearSearch.name,
        callback: (_) => _clearSearch(),
      )
      ..addObserver(
        this,
        name: NotificationName.updateList.name,
        callback: (_) => _updateList(),
      )
      ..addObserver(
        this,
        name: NotificationName.updateFilters.name,
        callback: _updateFilters,
      )
      ..addObserver(
        this,
        name: NotificationName.clearFilters.name,
        callback: (_) => _clearFilters(),
      );
  }

  @override
  void dispose() {
    NotificationDispatcher.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseRequestListView(
      emptyListingTextBuilder: (searchTerm, method, status) =>
          'No requests found with the following filters:\n\n'
          'Search term: "$searchTerm"\n'
          'Request method: ${(method?.name ?? '-').toUpperCase()}\n'
          'Response status: ${(status?.name ?? '-').toUpperCase()}\n',
      searchTerm: _searchTerm,
      filterByRequestMethod: _method,
      filterByResponseStatus: _status,
      responses: NetwolfController.instance.responses,
    );
  }

  void _search(NotificationMessage message) {
    final searchTerm = message.info?[NotificationKey.searchTerm.name];

    if (searchTerm is String) {
      setState(() => _searchTerm = searchTerm);
    }
  }

  void _clearSearch() {
    setState(() => _searchTerm = null);
  }

  void _updateList() {
    setState(() {});
  }

  void _updateFilters(NotificationMessage message) {
    final method = message.info?[NotificationKey.method.name];
    final status = message.info?[NotificationKey.status.name];

    if (method is HttpRequestMethod?) _method = method;
    if (status is HttpResponseStatus?) _status = status;

    setState(() {});
  }

  void _clearFilters() {
    setState(() {
      _method = null;
      _status = null;
    });
  }
}

class BaseRequestListView extends StatelessWidget {
  const BaseRequestListView({
    super.key,
    required this.emptyListingTextBuilder,
    this.searchTerm,
    this.filterByRequestMethod,
    this.filterByResponseStatus,
    required this.responses,
  });

  final EmptyListingTextBuilder emptyListingTextBuilder;
  final String? searchTerm;
  final HttpRequestMethod? filterByRequestMethod;
  final HttpResponseStatus? filterByResponseStatus;
  final List<NetwolfResponse> responses;

  @override
  Widget build(BuildContext context) {
    var filteredResponses = responses;

    if ((searchTerm ?? '').isNotEmpty) {
      filteredResponses = filteredResponses.toList()
        ..retainWhere(
          (e) =>
              e.url?.toLowerCase().contains(searchTerm!.toLowerCase()) ?? false,
        );
    }

    if (filterByRequestMethod != null) {
      filteredResponses = filteredResponses.toList()
        ..retainWhere((e) => e.method == filterByRequestMethod);
    }

    if (filterByResponseStatus != null) {
      filteredResponses = filteredResponses.toList()
        ..retainWhere((e) => e.status == filterByResponseStatus);
    }

    final showing = filteredResponses.length;
    final total = responses.length;

    return Column(
      children: [
        Text('Showing $showing of $total responses'),
        const SizedBox(height: 8),
        Expanded(
          child: filteredResponses.isEmpty
              ? _buildEmptyResponse()
              : _buildListing(context, filteredResponses),
        ),
      ],
    );
  }

  Widget _buildEmptyResponse() {
    return Center(
      child: Text(
        emptyListingTextBuilder(
          searchTerm ?? '',
          filterByRequestMethod,
          filterByResponseStatus,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildListing(
    BuildContext context,
    List<NetwolfResponse> responses,
  ) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: ListView.separated(
        itemCount: responses.length,
        itemBuilder: (context, index) =>
            NetwolfRequestListViewItem(responses[index]),
        separatorBuilder: (context, index) => const Divider(),
      ),
    );
  }
}

class NetwolfRequestListViewItem extends StatelessWidget {
  const NetwolfRequestListViewItem(this.response, {super.key});

  final NetwolfResponse response;

  @override
  Widget build(BuildContext context) {
    final method = response.method;
    final responseCode = response.responseCode;
    final status = response.status;
    final url = response.uri;
    final timestamp = response.startTime;
    final responseTime = response.responseTime;
    final completed = response.completed;

    return Column(
      children: [
        InkWell(
          onTap: () => showCustomModalBottomSheet<void>(
            context: context,
            builder: (_) => DetailsPage(response: response),
          ),
          child: Padding(
            padding: kDefaultPadding.copyWith(top: 12, bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildUrlPath(
                          context,
                          method: method,
                          url: url,
                          responseCode: responseCode,
                          status: status,
                        ),
                        const SizedBox(height: 8),
                        _buildUrl(context, url: url),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: status.toColor(),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 6,
                      ),
                      child: Text(
                        completed ? '$responseCode' : 'Pending',
                        style: Theme.of(context)
                            .textTheme
                            .caption
                            ?.copyWith(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _buildFooter(
                  context,
                  timestamp: timestamp,
                  responseTime: responseTime,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUrlPath(
    BuildContext context, {
    required HttpRequestMethod? method,
    required Uri? url,
    required int? responseCode,
    required HttpResponseStatus? status,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '${method?.name.toUpperCase()} ${url?.path ?? ''}',
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ],
    );
  }

  Widget _buildUrl(BuildContext context, {required Uri? url}) {
    return Text(
      '${url?.scheme}://${url?.host ?? ''}',
      style: Theme.of(context).textTheme.bodyText2,
    );
  }

  Widget _buildFooter(
    BuildContext context, {
    required DateTime timestamp,
    required Duration? responseTime,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(timestamp.toString(), style: Theme.of(context).textTheme.caption),
        if (responseTime != null)
          Text(
            '${responseTime.inMilliseconds} ms',
            style: Theme.of(context).textTheme.caption,
          ),
      ],
    );
  }
}
