import 'package:flutter/material.dart';
import 'package:netwolf/src/core/constants.dart';
import 'package:netwolf/src/core/enums.dart';
import 'package:netwolf/src/core/extensions.dart';
import 'package:netwolf/src/ui/widgets/base_dialog.dart';
import 'package:netwolf_core/netwolf_core.dart';

typedef OnFilterChanged = void Function(
  HttpRequestMethod?,
  HttpResponseStatus?,
);

class FilterDialog extends StatefulWidget {
  const FilterDialog({
    super.key,
    required this.initialRequestMethod,
    required this.initialResponseStatus,
    required this.onFilterChanged,
    required this.onFiltersCleared,
  });

  final HttpRequestMethod? initialRequestMethod;
  final HttpResponseStatus? initialResponseStatus;
  final OnFilterChanged onFilterChanged;
  final VoidCallback onFiltersCleared;

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  HttpRequestMethod? _selectedRequestMethod;
  HttpResponseStatus? _selectedResponseStatus;

  @override
  void initState() {
    super.initState();
    _selectedRequestMethod = widget.initialRequestMethod;
    _selectedResponseStatus = widget.initialResponseStatus;
  }

  @override
  Widget build(BuildContext context) {
    return BaseDialog(
      title: 'Filter',
      content: Column(
        children: [
          _SortingField<HttpRequestMethod>(
            'By method',
            value: _selectedRequestMethod,
            items: HttpRequestMethod.values,
            itemStringBuilder: (e) => e.name.toUpperCase(),
            onChanged: _onRequestMethodSelected,
          ),
          _SortingField<HttpResponseStatus>(
            'By status',
            value: _selectedResponseStatus,
            items: HttpResponseStatus.values,
            itemStringBuilder: (e) => '${e.name.camelToSentenceCase()}: '
                '${e.startRange} - ${e.endRange}',
            onChanged: _onRequestStatusSelected,
          ),
        ],
      ),
      buttons: [
        ElevatedButton(
          style: (Theme.of(context).elevatedButtonTheme.style ??
                  ElevatedButton.styleFrom())
              .copyWith(
            backgroundColor: MaterialStateProperty.all(kDestructiveColor),
          ),
          onPressed: _onClearFiltersPressed,
          child: const Text('Clear filters'),
        ),
      ],
    );
  }

  void _onRequestMethodSelected(HttpRequestMethod? value) {
    setState(() => _selectedRequestMethod = value);
    widget.onFilterChanged(value, _selectedResponseStatus);
  }

  void _onRequestStatusSelected(HttpResponseStatus? value) {
    setState(() => _selectedResponseStatus = value);
    widget.onFilterChanged(_selectedRequestMethod, value);
  }

  void _onClearFiltersPressed() {
    widget.onFiltersCleared();
    Navigator.of(context).pop();
  }
}

class _SortingField<T extends Object> extends StatelessWidget {
  const _SortingField(
    this.label, {
    this.value,
    required this.items,
    this.itemStringBuilder,
    this.onChanged,
  });

  final String label;
  final T? value;
  final List<T> items;
  final String Function(T)? itemStringBuilder;
  final ValueChanged<T?>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            overflow: TextOverflow.ellipsis,
            maxLines: 999,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 2,
          child: DropdownButton(
            value: value,
            isExpanded: true,
            items: items
                .map(
                  (e) => DropdownMenuItem(
                    value: e,
                    child: Text(
                      itemStringBuilder?.call(e) ?? e.toString(),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                )
                .toList()
              ..insert(0, const DropdownMenuItem(child: Text('All'))),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
