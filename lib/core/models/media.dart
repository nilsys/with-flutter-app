import 'package:flutter/foundation.dart';

class Media {
  final List<String> images;
  final List<String> videos;
  final List<String> audio;

  Media({
    @required this.images,
    @required this.videos,
    @required this.audio,
  });

  Media.fromMap(Map snapshot)
      : images = snapshot['images'].cast<String>().toList(),
        videos = snapshot['videos'].cast<String>().toList(),
        audio = snapshot['audio'].cast<String>().toList();

  toJson() {
    return {
      "images": images != null ? images : [],
      "videos": videos != null ? videos : [],
      "audio": audio != null ? audio : [],
    };
  }
}
