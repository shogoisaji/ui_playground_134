import 'package:flutter/material.dart';

class LottieAnimationController extends AnimationController {
  LottieAnimationController({
    required super.vsync,
    super.duration,
  });

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
    if (duration == null ||
        startSecond < 0 ||
        startSecond >= endSecond ||
        startSecond > duration!.inSeconds ||
        endSecond > duration!.inSeconds) {
      throw ArgumentError('Invalid start or end value');
    }

    _removeCurrentListener();

    if (reverse) {
      repeat(
          min: startSecond / duration!.inSeconds,
          max: endSecond / duration!.inSeconds,
          reverse: true,
          period: Duration(seconds: (endSecond - startSecond).toInt()));
    } else {
      value = startSecond / duration!.inSeconds;
      animateTo(endSecond / duration!.inSeconds);
      _listener = (status) {
        if (status == AnimationStatus.completed) {
          value = startSecond / duration!.inSeconds;
          animateTo(endSecond / duration!.inSeconds);
        }
      };
    }
    addStatusListener(_listener!);
  }

  Future<void> pointForward(double startSecond, double endSecond) async {
    if (duration == null ||
        startSecond < 0 ||
        startSecond >= endSecond ||
        startSecond > duration!.inSeconds ||
        endSecond > duration!.inSeconds) {
      throw ArgumentError('Invalid start or end value');
    }

    _removeCurrentListener();

    value = startSecond / duration!.inSeconds;
    return animateTo(endSecond / duration!.inSeconds);
  }

  void _removeCurrentListener() {
    if (_listener != null) {
      removeStatusListener(_listener!);
      _listener = null;
    }
  }
}
