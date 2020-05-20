import 'dart:ui' show Canvas, Image, Paint, Rect, Size;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show Colors, required;
import 'package:flutter/rendering.dart'
    show Canvas, EdgeInsets, Paint, PaintingStyle, Size;

final _backgroundPaint = Paint()
  ..style = PaintingStyle.fill
  ..color = Colors.white;

class Bird {
  final Image image;
  final EdgeInsets margins;
  Size _size;

  Bird({@required this.image, @required this.margins});

  resize(Size size) {
    _size = size;
  }

  update(double ts) {}

  void _debugCanvas(Canvas canvas) {
    canvas.drawRect(
        Rect.fromLTRB(
          margins.left,
          margins.top,
          _size.width,
          _size.height,
        ),
        _backgroundPaint);
  }

  render(Canvas canvas) {
    final width = _size.width - margins.left;
    final height = _size.height - margins.top;
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
      margins.left,
      margins.top,
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
