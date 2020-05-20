import 'dart:ui' show Canvas, Image, Offset, Paint, Rect, Size;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show Colors, required;
import 'package:flutter/rendering.dart' show Canvas, Paint, PaintingStyle, Size;

final _backgroundPaint = Paint()
  ..style = PaintingStyle.fill
  ..color = Colors.white;

enum Direction { Left, Right, Up, Down }

class Bird {
  final Image image;
  final Offset origin;
  Direction currentDirection;
  Size _size;

  Offset position;

  Bird({@required this.image, @required this.origin}) {
    position = Offset(origin.dx, origin.dy);
  }

  resize(Size size) {
    _size = size;
  }

  update(double ts) {}

  void moveBy(Offset delta) {
    currentDirection = this._determineDirection();
    position += delta;
  }

  void maybeCommit() {
    if (currentDirection == null) {
      position = origin;
    } else {
      debugPrint('dir: $currentDirection');
      position = origin;
    }
  }

  Direction _determineDirection() {
    const minDelta = 100.0;
    final dx = position.dx - origin.dx;
    final dy = position.dy - origin.dy;
    final absDx = dx.abs();
    final absDy = dy.abs();
    if (absDx < minDelta && absDy < minDelta) return null;
    if (absDx > absDy) {
      return dx < 0 ? Direction.Left : Direction.Right;
    } else {
      return dy < 0 ? Direction.Up : Direction.Down;
    }
  }

  void _debugCanvas(Canvas canvas) {
    canvas.drawRect(
        Rect.fromLTRB(
          origin.dx,
          origin.dy,
          _size.width,
          _size.height,
        ),
        _backgroundPaint);
  }

  render(Canvas canvas) {
    final width = _size.width - origin.dx;
    final height = _size.height - origin.dy;
    _debugCanvas(canvas);

    final src = Rect.fromLTWH(
      0,
      0,
      image.width.toDouble(),
      image.height.toDouble(),
    );

    final imageFill = _fillPreservingAspectRatio(Size(width, height),
        Size(image.width.toDouble(), image.height.toDouble()));
    final dst = Rect.fromLTWH(
      position.dx,
      position.dy,
      imageFill.width,
      imageFill.height,
    );
    canvas.drawImageRect(image, src, dst, Paint());
  }

  onAttach() {}
  onDetach() {}
}

Size _fillPreservingAspectRatio(Size bounds, Size size) {
  // TODO: when width and height are very close i.e. screen is almost square
  // we're running into sizing issues where image is larger than it should be
  // this maybe due to rounding errors, but doesn't matter too much ATM
  // as no tablet/phone is square
  if (bounds.width <= bounds.height) {
    final aspectRatio = size.width / size.height;
    final width = bounds.width;
    final height = width / aspectRatio;
    return Size(width, height);
  } else {
    final aspectRatio = size.width / size.height;
    final height = bounds.height;
    final width = height * aspectRatio;
    return Size(width, height);
  }
}
