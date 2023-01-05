import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:netwolf/netwolf.dart';
import 'package:netwolf/src/constants.dart';
import 'package:netwolf/src/dialogs/dialogs.dart';
import 'package:netwolf/src/extensions.dart';
import 'package:netwolf/src/widgets/widgets.dart';

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
            onChanged: (value) => setState(() {
              _selectedRequestMethod = value;
            }),
          ),
          _SortingField<HttpResponseStatus>(
            'By status',
            value: _selectedResponseStatus,
            items: HttpResponseStatus.values,
            itemStringBuilder: (e) => e.name.toTitleCase(),
            onChanged: (value) => setState(() {
              _selectedResponseStatus = value;
            }),
          ),
        ],
      ),
      buttons: Row(
        children: [
          const Spacer(),
          ElevatedButton(
            style: (Theme.of(context).elevatedButtonTheme.style ??
                    ElevatedButton.styleFrom())
                .copyWith(
              backgroundColor: MaterialStateProperty.all(kDestructiveColor),
            ),
            onPressed: () {
              widget.onClearFiltersPressed();
              NetwolfRouter.of(context).dismiss();
            },
            child: const Text('Clear filters'),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () {
              widget.onSorted(
                _selectedRequestMethod,
                _selectedResponseStatus,
              );
              NetwolfRouter.of(context).dismiss();
            },
            child: const Text('Apply'),
          ),
        ],
      ),
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
          child: _DropdownButton(
            value: value,
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

/// To mimic a [DropdownButton] because the [NetwolfWidget] is not
/// meant to wrap an existing [Navigator].
class _DropdownButton<T extends Object?> extends StatefulWidget {
  const _DropdownButton({
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final T? value;
  final List<DropdownMenuItem<T>>? items;
  final ValueChanged<T?>? onChanged;

  @override
  State<_DropdownButton<T>> createState() => _DropdownButtonState<T>();
}

class _DropdownButtonState<T extends Object?>
    extends State<_DropdownButton<T>> {
  BoxConstraints? _constraints;
  bool _isShown = false;

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Stack(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => setState(() {
              _isShown = !_isShown;
            }),
            child: PortalTarget(
              visible: _isShown,
              anchor: const Aligned(
                follower: Alignment.topCenter,
                target: Alignment.bottomCenter,
              ),
              portalFollower: Material(
                elevation: 8,
                child: SizedBox(
                  width: _constraints?.maxWidth,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: (widget.items ?? [])
                        .map(
                          (e) => InkWell(
                            onTap: () {
                              widget.onChanged?.call(e.value);
                              setState(() {
                                _isShown = false;
                              });
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: e,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  _constraints = constraints;

                  return IgnorePointer(
                    child: DropdownButton<T?>(
                      value: widget.value,
                      onChanged: widget.onChanged,
                      isExpanded: true,
                      items: widget.items,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
