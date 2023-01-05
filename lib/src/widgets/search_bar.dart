part of '../widget.dart';

class _SearchBar extends StatefulWidget {
  const _SearchBar({
    required this.controller,
  });

  final NetwolfController controller;

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
    return Focus(
      onFocusChange: (value) => widget.controller._search(_controller.text),
      child: TextField(
        controller: _controller,

        // Disable selection to prevent looking up the widget tree
        // for a non-existent Overlay widget.
        enableInteractiveSelection: false,
        decoration: InputDecoration(
          hintText: 'Search by URL',
          suffixIcon: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              _controller.clear();
              FocusManager.instance.primaryFocus?.unfocus();
              widget.controller._clearSearch();
            },
          ),
        ),
      ),
    );
  }

  void _onChanged() {
    widget.controller._search(_controller.text);
  }
}
