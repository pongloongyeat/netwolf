import 'package:flutter/material.dart';
import 'package:netwolf/netwolf.dart';
import 'package:netwolf/src/constants.dart';
import 'package:netwolf/src/dialogs/dialogs.dart';
import 'package:netwolf/src/extensions.dart';

class FilterDialog extends StatefulWidget {
  const FilterDialog({
    super.key,
    required this.initialRequestMethod,
    required this.initialResponseStatus,
    required this.onClearFiltersPressed,
    required this.onSorted,
  });

  final HttpRequestMethod? initialRequestMethod;
  final HttpResponseStatus? initialResponseStatus;
  final VoidCallback onClearFiltersPressed;
  final void Function(HttpRequestMethod?, HttpResponseStatus?) onSorted;

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
            onChanged: (value) {
              setState(() => _selectedRequestMethod = value);
              widget.onSorted(_selectedRequestMethod, _selectedResponseStatus);
            },
          ),
          _SortingField<HttpResponseStatus>(
            'By status',
            value: _selectedResponseStatus,
            items: HttpResponseStatus.values,
            itemStringBuilder: (e) => '${e.name.camelToSentenceCase()}: '
                '${e.responseCodeStart} - ${e.responseCodeEnd}',
            onChanged: (value) {
              setState(() => _selectedResponseStatus = value);
              widget.onSorted(_selectedRequestMethod, _selectedResponseStatus);
            },
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
          onPressed: () {
            widget.onClearFiltersPressed();
            Navigator.of(context).pop();
          },
          child: const Text('Clear filters'),
        ),
      ],
    );
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
            style: kLabelTextStyle,
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
                    child: Text(itemStringBuilder?.call(e) ?? e.toString()),
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
