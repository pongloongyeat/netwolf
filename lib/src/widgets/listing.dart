part of '../widget.dart';

class _RequestListView extends StatefulWidget {
  const _RequestListView({
    super.key,
    required this.controller,
  });

  final NetwolfController controller;

  @override
  State<_RequestListView> createState() => _RequestListViewState();
}

class _RequestListViewState extends State<_RequestListView> {
  @override
  Widget build(BuildContext context) {
    return AnimatedIndexedStack(
      index: widget.controller._isSearching ? 0 : 1,
      children: [
        _BaseRequestListView(
          emptyListingTextBuilder: (searchTerm, method, status) =>
              'No requests found with the following filters:\n\n'
              'Search term: "$searchTerm"\n'
              // ignore: lines_longer_than_80_chars
              'Filter by request method: ${(method?.name ?? '').toUpperCase()}\n'
              // ignore: lines_longer_than_80_chars
              'Filter by response status: ${(status?.name ?? '').toUpperCase()}\n',
          searchTerm: widget.controller._searchTerm,
          filterByRequestMethod: widget.controller._filteredMethod,
          filterByResponseStatus: widget.controller._filteredStatus,
          controller: widget.controller,
          responses: widget.controller.responses,
        ),
        _BaseRequestListView(
          emptyListingTextBuilder: (_, __, ___) =>
              'No requests recorded.\nSend a network request to begin.',
          responses: widget.controller.responses,
          controller: widget.controller,
        ),
      ],
    );
  }

  void markNeedsBuild() => setState(() {});
}

class _BaseRequestListView extends StatelessWidget {
  const _BaseRequestListView({
    required this.emptyListingTextBuilder,
    this.searchTerm,
    this.filterByRequestMethod,
    this.filterByResponseStatus,
    required this.controller,
    required this.responses,
  });

  final String Function(
    String searchTerm,
    HttpRequestMethod? method,
    HttpResponseStatus? status,
  ) emptyListingTextBuilder;
  final String? searchTerm;
  final HttpRequestMethod? filterByRequestMethod;
  final HttpResponseStatus? filterByResponseStatus;
  final NetwolfController controller;

  final List<NetwolfResponseWithRelativeTimestamp> responses;

  bool get shouldFilter =>
      (searchTerm ?? '').isNotEmpty ||
      filterByRequestMethod != null ||
      filterByResponseStatus != null;

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
        itemBuilder: (context, index) => _itemBuilder(
          context,
          responses[index],
        ),
      ),
    );
  }

  Widget _itemBuilder(
    BuildContext context,
    NetwolfResponseWithRelativeTimestamp response,
  ) {
    final method = response.response.method;
    final status = response.response.status;
    final url = response.response.url;
    final timestampInMs = response.relativeTimestampInMilliseconds;

    final milliseconds = timestampInMs % 1000;
    final seconds = ((timestampInMs / 1000) % 60).floor();
    final minutes = (timestampInMs / 1000 / 60).floor();

    return InkWell(
      onTap: () => NetwolfRouter.of(context)
          .push(ResponseDetails(controller: controller, response: response)),
      child: Row(
        children: [
          Expanded(
            child: ColoredBox(
              color: status.toColor().withOpacity(0.9),
              child: AspectRatio(
                aspectRatio: 1,
                child: Center(
                  child: Text(
                    '${status?.name}'.toUpperCase(),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  url.toString(),
                  style: const TextStyle(fontSize: 16),
                ),
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
