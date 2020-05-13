import 'dart:ui' show Canvas, Image, Paint, Size;

import 'package:flutter/material.dart' show Colors, Size, required;
import 'package:flutter/rendering.dart';

final _birdPaint = Paint()
  ..style = PaintingStyle.fill
  ..color = Colors.black45;                    

class Bird {
  final Image image;

  Bird({@required this.image});

  resize(Size size) {
  }

  update(double ts) {}

  render(Canvas canvas) {
    // TODO: figure out how to position canvas below title
    // canvas.drawImage(image, Offset.zero, Paint());
    canvas.drawRect(Rect.fromLTWH(10, 100, 100, 100), _birdPaint);
  }

  onAttach() {}
  onDetach() {}
}
