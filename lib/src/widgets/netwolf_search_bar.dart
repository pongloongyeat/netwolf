import 'package:flutter/material.dart';
import 'package:netwolf/src/dialogs/dialogs.dart';
import 'package:netwolf/src/enums.dart';
import 'package:notification_dispatcher/notification_dispatcher.dart';

class NetwolfSearchBar extends StatefulWidget {
  const NetwolfSearchBar({super.key});

  @override
  State<NetwolfSearchBar> createState() => _NetwolfSearchBarState();
}

class _NetwolfSearchBarState extends State<NetwolfSearchBar> {
  HttpRequestMethod? _method;
  HttpResponseStatus? _status;

  @override
  void initState() {
    super.initState();
    NotificationDispatcher.instance
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
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: SearchBar()),
        const SizedBox(width: 8),
        IconButton(
          icon: Icon(Icons.sort, color: Colors.grey[600]),
          onPressed: () => showDialog<void>(
            context: context,
            builder: (dialogContext) => FilterDialog(
              initialRequestMethod: _method,
              initialResponseStatus: _status,
              onClearFiltersPressed: () => NotificationDispatcher.instance.post(
                name: NotificationName.clearFilters.name,
              ),
              onSorted: (method, status) =>
                  NotificationDispatcher.instance.post(
                name: NotificationName.updateFilters.name,
                info: {
                  NotificationKey.method.name: method,
                  NotificationKey.status.name: status,
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _updateFilters(NotificationMessage message) {
    final method = message.info?[NotificationKey.method.name];
    final status = message.info?[NotificationKey.status.name];

    if (method is HttpRequestMethod?) _method = method;
    if (status is HttpResponseStatus?) _status = status;
  }

  void _clearFilters() {
    _method = null;
    _status = null;
  }
}

class SearchBar extends StatefulWidget {
  const SearchBar({super.key});

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onChanged);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (_) => _onChanged(),
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
          hintText: 'Search by URL',
          suffixIcon: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              _controller.clear();
              FocusManager.instance.primaryFocus?.unfocus();
              NotificationDispatcher.instance
                  .post(name: NotificationName.clearSearch.name);
            },
          ),
        ),
      ),
    );
  }

  void _onChanged() {
    NotificationDispatcher.instance.post(
      name: NotificationName.search.name,
      info: {
        NotificationKey.searchTerm.name: _controller.text,
      },
    );
  }
}
