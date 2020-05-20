import 'dart:ui' show Canvas, Image, Offset, Paint, Rect, Size;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show Colors, required;
import 'package:flutter/rendering.dart' show Canvas, Paint, PaintingStyle, Size;

final _backgroundPaint = Paint()
  ..style = PaintingStyle.fill
  ..color = Colors.white;

enum Direction { Left, Right, Up, Down }

const _animationScale = 0.25;

class Bird {
  final Image image;
  final Offset origin;
  Direction currentDirection;
  bool _animating;
  Offset _animationVector;

  Size _size;

  Offset position;

  Bird({@required this.image, @required this.origin})
      : _animating = false,
        currentDirection = null {
    position = Offset(origin.dx, origin.dy);
  }

  double get width => _size.width - origin.dx;
  double get height => _size.height - origin.dy;

  resize(Size size) {
    _size = size;
  }

  update(double ts) {
    if (!_animating) return;
    assert(currentDirection != null, 'cannot animate without direction');
    assert(_animationVector != null, 'cannot animate a vector');

    position = position.translate(_animationVector.dx, _animationVector.dy);
    if (this._outOfBounds()) {
      _animating = false;
      currentDirection = null;
      position = origin;
    }
  }

  void moveBy(Offset delta) {
    if (_animating) return;
    currentDirection = this._determineDirection();
    position += delta;
  }

  void maybeCommit() {
    if (currentDirection == null) {
      position = origin;
    } else {
      _animating = true;
      _animationVector =
          Offset(position.dx - origin.dx, position.dy - origin.dy)
              .scale(_animationScale, _animationScale);
    }
  }

  bool _outOfBounds() {
    const percent = 0.8 * 2;
    return (position.dx < (-width * percent)) ||
        (position.dx > (width * percent)) ||
        (position.dy < (-height * percent)) ||
        (position.dy > (height * percent));
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
