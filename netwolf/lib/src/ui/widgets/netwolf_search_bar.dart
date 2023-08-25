import 'package:flutter/material.dart';
import 'package:netwolf/src/ui/widgets/filter_dialog.dart';
import 'package:netwolf_core/netwolf_core.dart';
import 'package:notification_dispatcher/notification_dispatcher.dart';

class NetwolfSearchBar extends StatelessWidget {
  const NetwolfSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(child: _SearchBar()),
        _FilterButton(),
      ],
    );
  }
}

class _FilterButton extends StatefulWidget {
  const _FilterButton();

  @override
  State<_FilterButton> createState() => _FilterButtonState();
}

class _FilterButtonState extends State<_FilterButton> {
  HttpRequestMethod? _method;
  HttpResponseStatus? _status;

  @override
  void initState() {
    super.initState();
    NotificationDispatcher.instance
      ..addObserver(
        this,
        name: NotificationName.updateFilters.name,
        callback: _onFiltersUpdated,
      )
      ..addObserver(
        this,
        name: NotificationName.clearFilters.name,
        callback: _onFiltersCleared,
      );
  }

  @override
  void dispose() {
    NotificationDispatcher.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.sort, color: Colors.grey[600]),
      onPressed: () => showDialog<void>(
        context: context,
        builder: (_) => FilterDialog(
          initialRequestMethod: _method,
          initialResponseStatus: _status,
        ),
      ),
    );
  }

  void _onFiltersUpdated(NotificationMessage message) {
    final method = message.info?[NotificationKey.method.name];
    final status = message.info?[NotificationKey.method.name];

    if (method is HttpRequestMethod) _method = method;
    if (status is HttpResponseStatus) _status = status;
  }

  void _onFiltersCleared(NotificationMessage _) {
    _method = null;
    _status = null;
  }
}

class _SearchBar extends StatefulWidget {
  const _SearchBar();

  @override
  State<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
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
    return TextField(
      controller: _controller,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: 'Search by URL',
        suffixIcon: IconButton(
          icon: const Icon(Icons.close),
          onPressed: _onClear,
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

  void _onClear() {
    _controller.clear();
    _onChanged();
  }
}
