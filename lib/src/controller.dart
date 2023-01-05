// ignore_for_file: public_member_api_docs

part of 'widget.dart';

class NetwolfResponseWithRelativeTimestamp {
  NetwolfResponseWithRelativeTimestamp({
    required this.response,
    required this.relativeTimestampInMilliseconds,
  });

  final NetwolfResponse response;
  final int relativeTimestampInMilliseconds;
}

class NetwolfController {
  NetwolfController._(
    this._widgetKey,
    this._listingKey,
    this._intitialTimestamp,
  );

  static final instance = NetwolfController._(
    GlobalKey<_NetwolfWidgetState>(),
    GlobalKey<_RequestListViewState>(),
    DateTime.now(),
  );

  final GlobalKey<_NetwolfWidgetState> _widgetKey;
  final GlobalKey<_RequestListViewState> _listingKey;
  final DateTime _intitialTimestamp;

  final responses = <NetwolfResponseWithRelativeTimestamp>[];

  bool _enabled = true;
  bool get enabled => _enabled;

  bool get _isSearching =>
      (_searchTerm ?? '').isNotEmpty ||
      _filteredMethod != null ||
      _filteredStatus != null;

  String? _searchTerm;
  HttpRequestMethod? _filteredMethod;
  HttpResponseStatus? _filteredStatus;

  void show() {
    if (enabled) _widgetKey.currentState!.showNetwolf();
  }

  void hide() {
    _widgetKey.currentState!.hideNetwolf();
  }

  void addResponse(NetwolfResponse response) {
    if (!enabled) return;

    responses.insert(
      0,
      NetwolfResponseWithRelativeTimestamp(
        response: response,
        relativeTimestampInMilliseconds:
            response.timeStamp.difference(_intitialTimestamp).inMilliseconds,
      ),
    );
    _updateListUi();
  }

  void clearResponses() {
    responses.clear();
    _filteredMethod = null;
    _filteredStatus = null;
    _updateListUi();
  }

  void updateFilter(HttpRequestMethod? method, HttpResponseStatus? status) {
    _filteredMethod = method;
    _filteredStatus = status;
    _updateListUi();
  }

  void _search(String searchTerm) {
    _searchTerm = searchTerm;
    _updateListUi();
  }

  void _clearSearch() {
    _searchTerm = null;
    _updateListUi();
  }

  void _clearFilters() {
    _filteredMethod = null;
    _filteredStatus = null;
    _updateListUi();
  }

  void _enable() => _enabled = true;
  void _disable() => _enabled = false;
  void _updateListUi() {
    if (enabled) _listingKey.currentState?.markNeedsBuild();
  }
}
