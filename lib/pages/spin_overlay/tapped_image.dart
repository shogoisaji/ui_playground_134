import 'package:flutter/material.dart';

class TappedImage {
  final Offset offset;
  final Size size;
  final String imageLink;

  const TappedImage({
    required this.offset,
    required this.size,
    required this.imageLink,
  });

  TappedImage copyWith({
    Offset? offset,
    Size? size,
    String? imageLink,
  }) {
    return TappedImage(
      offset: offset ?? this.offset,
      size: size ?? this.size,
      imageLink: imageLink ?? this.imageLink,
    );
  }
}
