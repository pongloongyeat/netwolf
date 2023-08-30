import 'package:flutter/material.dart';
import 'package:netwolf/src/core/constants.dart';
import 'package:netwolf/src/core/enums.dart';

extension StringX on String {
  String toTitleCase() {
    if (length < 1) return this;

    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }

  String camelToSentenceCase() {
    return replaceAll(RegExp('(?<!^)(?=[A-Z])'), ' ').toTitleCase();
  }
}

extension HttpResponseStatusX on HttpResponseStatus? {
  Color toColor() {
    switch (this) {
      case HttpResponseStatus.success:
        return kSuccessColor;
      case HttpResponseStatus.clientError:
      case HttpResponseStatus.serverError:
        return kErrorColor;
      case HttpResponseStatus.info:
      case HttpResponseStatus.redirect:
      case null:
        return kUnknownColor;
    }
  }
}

extension ListWidgetExtensions on List<Widget> {
  List<Widget> joined(
    Widget? separator, {
    bool applyBeforeFirstItem = false,
    bool applyAfterLastItem = false,
    bool reverse = false,
  }) {
    if (separator == null || length <= 1) return this;

    final widgets = <Widget>[];

    if (applyBeforeFirstItem) widgets.add(separator);

    for (var i = 0; i < length - 1; i++) {
      final index = reverse ? length - 1 - i : i;

      final widget = this[index];
      widgets
        ..add(widget)
        ..add(separator);
    }

    widgets.add(last);

    if (applyAfterLastItem) widgets.add(separator);
    return widgets;
  }
}
