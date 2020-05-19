import 'dart:ui' show Canvas, Image, Offset, Paint, Rect, Size;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show Colors, required;
import 'package:flutter/rendering.dart' show Canvas, Paint, PaintingStyle, Size;

final _birdPaint = Paint()
  ..style = PaintingStyle.fill
  ..color = Colors.black45;

class Bird {
  final Image image;
  Size _size;

  Bird({@required this.image});

  resize(Size size) {
    _size = size;
  }

  update(double ts) {}

  render(Canvas canvas) {
    // TODO: figure out how to position canvas below title
    const marginTop = 100.0;
    final ratio = _size.width / image.width;
    final height = _size.height * ratio;
    final src = Rect.fromLTWH(
      0,
      0,
      image.width.toDouble(),
      image.height.toDouble(),
    );
    final dst = Rect.fromLTWH(
      0,
      marginTop,
      this._size.width,
      height,
    );
    canvas.drawImageRect(image, src, dst, Paint());
  }

  onAttach() {}
  onDetach() {}
}
