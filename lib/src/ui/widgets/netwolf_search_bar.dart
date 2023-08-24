import 'package:flutter/material.dart';
import 'package:netwolf/src/enums.dart';
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

class _FilterButton extends StatelessWidget {
  const _FilterButton();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.sort, color: Colors.grey[600]),
      onPressed: () {},
    );
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
