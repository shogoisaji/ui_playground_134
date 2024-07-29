import 'package:flutter/widgets.dart';

class CardModel {
  const CardModel({
    required this.beforeChild,
    required this.afterChild,
    required this.beforeWidth,
    required this.beforeHeight,
    required this.afterWidth,
    required this.afterHeight,
    required this.initialPosition,
    this.position,
    required this.initialAngle,
    this.currentAngle,
    this.distance,
  });

  final Widget beforeChild;
  final Widget afterChild;
  final double beforeWidth;
  final double beforeHeight;
  final double afterWidth;
  final double afterHeight;
  final Offset initialPosition;
  final Offset? position;
  final double initialAngle;
  final double? currentAngle;
  final double? distance;

  CardModel copyWith({
    Offset? position,
    double? currentAngle,
    double? distance,
  }) {
    double validatedAngle = currentAngle ?? this.currentAngle ?? initialAngle;
    if (initialAngle < 0) {
      validatedAngle = validatedAngle.clamp(initialAngle, 0.0);
    } else {
      validatedAngle = validatedAngle.clamp(0.0, initialAngle);
    }
    return CardModel(
      beforeChild: beforeChild,
      afterChild: afterChild,
      beforeWidth: beforeWidth,
      beforeHeight: beforeHeight,
      afterWidth: afterWidth,
      afterHeight: afterHeight,
      initialPosition: initialPosition,
      initialAngle: initialAngle,
      position: position ?? this.position,
      currentAngle: validatedAngle,
      distance: distance ?? this.distance,
    );
  }
}
