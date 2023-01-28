import 'package:flutter/material.dart';
import 'package:netwolf/netwolf.dart';
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
  final List<NetwolfResponseWithRelativeTimestamp> responses;

  @override
  Widget build(BuildContext context) {
    var filteredResponses = responses;

    if ((searchTerm ?? '').isNotEmpty) {
      filteredResponses = filteredResponses.toList()
        ..retainWhere(
          (e) =>
              e.response.url
                  ?.toLowerCase()
                  .contains(searchTerm!.toLowerCase()) ??
              false,
        );
    }

    if (filterByRequestMethod != null) {
      filteredResponses = filteredResponses.toList()
        ..retainWhere((e) => e.response.method == filterByRequestMethod);
    }

    if (filterByResponseStatus != null) {
      filteredResponses = filteredResponses.toList()
        ..retainWhere((e) => e.response.status == filterByResponseStatus);
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
    List<NetwolfResponseWithRelativeTimestamp> responses,
  ) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: ListView.builder(
        itemCount: responses.length,
        itemBuilder: (context, index) =>
            NetwolfRequestListViewItem(responses[index]),
      ),
    );
  }
}

class NetwolfRequestListViewItem extends StatelessWidget {
  const NetwolfRequestListViewItem(this.response, {super.key});

  final NetwolfResponseWithRelativeTimestamp response;

  @override
  Widget build(BuildContext context) {
    final method = response.response.method;
    final responseCode = response.response.responseCode;
    final status = response.response.status;
    final url = response.response.url;
    final relativeTimestamp = response.relativeTimestamp;
    final timestampInMs = relativeTimestamp.inMilliseconds;

    final milliseconds = timestampInMs % 1000;
    final seconds = ((timestampInMs / 1000) % 60).floor();
    final minutes = (timestampInMs / 1000 / 60).floor();

    return InkWell(
      onTap: () => showCustomModalBottomSheet<void>(
        context: context,
        builder: (_) => DetailsPage(response: response),
      ),
      child: Row(
        children: [
          Expanded(
            child: ColoredBox(
              color: status.toColor().withOpacity(0.9),
              child: AspectRatio(
                aspectRatio: 1,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('$responseCode'),
                      const SizedBox(height: 4),
                      Text(
                        '${method?.name}'.toUpperCase(),
                        style: const TextStyle(
                          fontWeight: FontWeight.w300,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 3,
            child: Text(
              url.toString(),
              style: const TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              '${minutes}m\n${seconds}s\n${milliseconds}ms',
              textAlign: TextAlign.end,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
    );
  }
}
