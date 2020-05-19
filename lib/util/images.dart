import 'dart:async' show Completer, Future;
import 'dart:typed_data' show Uint8List;
import 'dart:ui' show Image, decodeImageFromList;

import 'package:flutter/services.dart' show rootBundle;

class Images {
  static Future<Image> loadFromMemory(String path) async {
    final data = await rootBundle.load(path);
    final bytes = Uint8List.view(data.buffer);
    final completer = Completer<Image>();
    decodeImageFromList(bytes, completer.complete);
    return completer.future;
  }
}
