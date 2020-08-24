import 'package:flutter/foundation.dart';

class MediaItem {
  final String src;
  final String type;

  MediaItem({
    @required this.src,
    @required this.type,
  });

  MediaItem.fromMap(Map snapshot)
      : src = snapshot['src'],
        type = snapshot['type'];

  toJson() {
    return {
      "src": src,
      "type": type,
    };
  }
}
