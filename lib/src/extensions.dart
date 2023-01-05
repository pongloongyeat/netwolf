import 'package:flutter/material.dart';
import 'package:netwolf/netwolf.dart';
import 'package:netwolf/src/constants.dart';

extension StringX on String {
  String toTitleCase() {
    if (length < 1) return this;

    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }
}

extension HttpResponseStatusX on HttpResponseStatus? {
  Color toColor() {
    switch (this) {
      case HttpResponseStatus.success:
        return kSuccessColor;
      case HttpResponseStatus.failed:
        return kErrorColor;
      case null:
        return kUnknownColor;
    }
  }
}

extension IterableX<E> on Iterable<E> {
  /// Checks whether all elements of this iterable satisfies [test].
  ///
  /// Checks every element in iteration order, and returns `false` if
  /// any of them make [test] return `false`, otherwise returns true.
  ///
  /// Example:
  /// ```dart
  /// final numbers = <int>[1, 2, 3, 5, 6, 7];
  /// var result = numbers.all((element) => element >= 5); // false;
  /// result = numbers.all((element) => element >= 1); // true;
  /// ```
  bool all(bool Function(E element) test) {
    for (final element in this) {
      if (!test(element)) return false;
    }
    return true;
  }
}
