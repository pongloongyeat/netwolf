import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// Similar to a regular [GestureDetector] but uses [Listener] under the
/// hood instead of [RawGestureDetector] with a [SerialTapGestureRecognizer].
class SerialGestureDetector extends StatefulWidget {
  const SerialGestureDetector({
    super.key,
    this.count,
    this.onSerialTap,
    required this.child,
  });

  /// The number of consecutive taps to be counted as a
  /// successful tap. A consecutive tap is defined as a tap
  /// that occurs [kDoubleTapTimeout] after a previous tap
  /// within a distance of [kDoubleTapSlop].
  final int? count;

  /// The callback that is called when a successful tap occurs.
  /// If [count] is null, this is never called.
  final VoidCallback? onSerialTap;

  final Widget child;

  @override
  State<SerialGestureDetector> createState() => _SerialGestureDetectorState();
}

class _SerialGestureDetectorState extends State<SerialGestureDetector> {
  late Timer _timer;

  int _count = 0;
  Offset? _initialPosition;

  @override
  void initState() {
    super.initState();
    _timer = Timer(kDoubleTapTimeout, _resetCount);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _incrementCount,
      child: widget.child,
    );
  }

  void _resetCount() {
    _count = 0;
    _initialPosition = null;
  }

  void _resetTimer() {
    _timer.cancel();
    _timer = Timer(kDoubleTapTimeout, _resetCount);
  }

  void _incrementCount(TapDownDetails event) {
    if (!_isWithinGlobalTolerance(event, kDoubleTapSlop)) {
      _resetCount();
      return;
    }

    _resetTimer();
    _count++;
    _initialPosition = _initialPosition ?? event.globalPosition;

    if (_count == widget.count) {
      _resetCount();
      widget.onSerialTap?.call();
    }
  }

  bool _isWithinGlobalTolerance(TapDownDetails event, double tolerance) {
    // If _initialPosition is null, it means we haven't yet had a tap event,
    // meaning this should be our first tap.
    if (_initialPosition == null) return true;

    final offset = event.globalPosition - _initialPosition!;
    return offset.distance <= tolerance;
  }
}
