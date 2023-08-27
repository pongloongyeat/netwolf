import 'package:flutter/material.dart';
import 'package:netwolf/src/core/enums.dart';
import 'package:netwolf/src/ui/widgets/filter_dialog.dart';

class NetwolfSearchBar extends StatelessWidget {
  const NetwolfSearchBar({
    super.key,
    required this.onSearchChanged,
    required this.onFilterChanged,
    required this.onFiltersCleared,
  });

  final ValueChanged<String> onSearchChanged;
  final OnFilterChanged onFilterChanged;
  final VoidCallback onFiltersCleared;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _SearchBar(
            onSearchChanged: onSearchChanged,
          ),
        ),
        _FilterButton(
          onFilterChanged: onFilterChanged,
          onFiltersCleared: onFiltersCleared,
        ),
      ],
    );
  }
}

class _FilterButton extends StatefulWidget {
  const _FilterButton({
    required this.onFilterChanged,
    required this.onFiltersCleared,
  });

  final OnFilterChanged onFilterChanged;
  final VoidCallback onFiltersCleared;

  @override
  State<_FilterButton> createState() => _FilterButtonState();
}

class _FilterButtonState extends State<_FilterButton> {
  HttpRequestMethod? _method;
  HttpResponseStatus? _status;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.sort, color: Colors.grey[600]),
      onPressed: () => showDialog<void>(
        context: context,
        builder: (_) => FilterDialog(
          initialRequestMethod: _method,
          initialResponseStatus: _status,
          onFilterChanged: _onFiltersUpdated,
          onFiltersCleared: _onFiltersCleared,
        ),
      ),
    );
  }

  void _onFiltersUpdated(
    HttpRequestMethod? method,
    HttpResponseStatus? status,
  ) {
    _method = method;
    _status = status;

    widget.onFilterChanged(method, status);
  }

  void _onFiltersCleared() {
    widget.onFiltersCleared();
  }
}

class _SearchBar extends StatefulWidget {
  const _SearchBar({
    required this.onSearchChanged,
  });

  final ValueChanged<String> onSearchChanged;

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
    widget.onSearchChanged(_controller.text);
  }

  void _onClear() {
    _controller.clear();
    _onChanged();
  }
}
