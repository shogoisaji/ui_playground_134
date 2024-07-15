import 'package:flutter/material.dart';

class LottieAnimationController extends AnimationController {
  /// [animationRangeSeconds]アニメーションの全体の長さ: 秒
  LottieAnimationController({
    required this.animationRangeSeconds,
    required super.vsync,
    super.duration,
  });
  final double animationRangeSeconds;

  @override
  void dispose() {
    super.dispose();
    _removeCurrentListener();
  }

  AnimationStatusListener? _listener;

  void pointLoop(
    double startSecond,
    double endSecond, {
    bool reverse = false,
  }) {
    if (startSecond < 0 ||
        startSecond >= endSecond ||
        startSecond > animationRangeSeconds ||
        endSecond > animationRangeSeconds) {
      throw ArgumentError('Invalid start or end value');
    }

    _removeCurrentListener();

    if (reverse) {
      repeat(
          min: startSecond / animationRangeSeconds,
          max: endSecond / animationRangeSeconds,
          reverse: true,
          period: Duration(seconds: (endSecond - startSecond).toInt()));
    } else {
      value = startSecond / animationRangeSeconds;
      animateTo(endSecond / animationRangeSeconds);
      _listener = (status) {
        if (status == AnimationStatus.completed) {
          value = startSecond / animationRangeSeconds;
          animateTo(endSecond / animationRangeSeconds);
        }
      };
    }
    addStatusListener(_listener!);
  }

  Future<void> pointForward(double startSecond, double endSecond) async {
    if (startSecond < 0 ||
        startSecond >= endSecond ||
        startSecond > animationRangeSeconds ||
        endSecond > animationRangeSeconds) {
      throw ArgumentError('Invalid start or end value');
    }

    _removeCurrentListener();

    value = startSecond / animationRangeSeconds;
    return animateTo(endSecond / animationRangeSeconds);
  }

  void _removeCurrentListener() {
    if (_listener != null) {
      removeStatusListener(_listener!);
      _listener = null;
    }
  }
}
