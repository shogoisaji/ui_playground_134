import 'package:flutter/material.dart';

class LottieAnimationController extends AnimationController {
  /// [animationLengthSeconds]アニメーションの全体の長さ: 秒
  LottieAnimationController({
    required this.animationLengthSeconds,
    required super.vsync,
    super.duration,
  });
  final double animationLengthSeconds;

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
        startSecond > animationLengthSeconds ||
        endSecond > animationLengthSeconds) {
      throw ArgumentError('Invalid start or end value');
    }

    _removeCurrentListener();

    if (reverse) {
      repeat(
          min: startSecond / animationLengthSeconds,
          max: endSecond / animationLengthSeconds,
          reverse: true,
          period: Duration(seconds: (endSecond - startSecond).toInt()));
    } else {
      value = startSecond / animationLengthSeconds;
      animateTo(endSecond / animationLengthSeconds);
      _listener = (status) {
        if (status == AnimationStatus.completed) {
          value = startSecond / animationLengthSeconds;
          animateTo(endSecond / animationLengthSeconds);
        }
      };
    }
    addStatusListener(_listener!);
  }

  Future<void> pointForward(double startSecond, double endSecond) async {
    if (startSecond < 0 ||
        startSecond >= endSecond ||
        startSecond > animationLengthSeconds ||
        endSecond > animationLengthSeconds) {
      throw ArgumentError('Invalid start or end value');
    }

    _removeCurrentListener();

    value = startSecond / animationLengthSeconds;
    return animateTo(endSecond / animationLengthSeconds);
  }

  void _removeCurrentListener() {
    if (_listener != null) {
      removeStatusListener(_listener!);
      _listener = null;
    }
  }
}
