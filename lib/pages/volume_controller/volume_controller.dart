import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class VolumeController extends StatefulWidget {
  const VolumeController({
    super.key,
    this.child,
    required this.value,
    this.size,
    required this.onChanged,
    this.hapticFeedbackSpan,
    this.maxValue,
    this.minValue,
  });

  final Widget? child;

  final double value;

  final double? size;

  final double? maxValue;
  final double? minValue;

  /// 1.0 per round.
  final ValueChanged<double> onChanged;

  /// ハプティックフィードバックの間隔
  final double? hapticFeedbackSpan;

  @override
  State<VolumeController> createState() => _VolumeControllerState();
}

class _VolumeControllerState extends State<VolumeController> {
  double _lastHapticFeedbackValue = 0.0;
  double _prevAngle = 0.0;

  /// タッチ位置から中心点に対する角度を計算
  double _calcAngle(BuildContext context, Offset globalPosition) {
    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return 0.0;
    final center = renderBox.size.center(Offset.zero);
    final position = renderBox.globalToLocal(globalPosition);
    double angle = math.atan2(position.dy - center.dy, position.dx - center.dx);
    return angle < 0 ? angle + 2 * math.pi : angle;
  }

  void _updateStartAngle(double angle) {
    setState(() {
      _prevAngle = angle;
    });
  }

  void _updateVolume(double angle) {
    final double deltaAngle = _calculateDeltaAngle(angle);
    _prevAngle = angle;

    /// デバイスの確認 (Chrome または iOS, Android)
    /// デバイスによって角度の変化が大きくなるため、調整
    final double deviceAdjust = _getDeviceAdjustment();

    final currentValue = widget.value + deltaAngle / (math.pi * deviceAdjust);

    if (_isValueOutOfRange(currentValue)) return;

    _applyHapticFeedback(currentValue);

    /// update parent value
    widget.onChanged(currentValue);
  }

  double _calculateDeltaAngle(double angle) {
    final delta = angle - _prevAngle;
    if (delta > math.pi) return delta - 2 * math.pi;
    if (delta < -math.pi) return delta + 2 * math.pi;
    return delta;
  }

  bool _isValueOutOfRange(double value) {
    return (widget.maxValue != null && value > widget.maxValue!) ||
        (widget.minValue != null && value < widget.minValue!);
  }

  double _getDeviceAdjustment() {
    if (Theme.of(context).platform == TargetPlatform.iOS ||
        Theme.of(context).platform == TargetPlatform.android) {
      return 2.0;
    }
    return 1.0;
  }

  void _applyHapticFeedback(double currentValue) {
    if (widget.hapticFeedbackSpan != null &&
        (currentValue - _lastHapticFeedbackValue).abs() >
            widget.hapticFeedbackSpan!) {
      HapticFeedback.lightImpact();
      _lastHapticFeedbackValue = currentValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (details) {
        final globalPosition = details.globalPosition;
        final angle = _calcAngle(context, globalPosition);
        _updateStartAngle(angle);
      },
      onPanUpdate: (details) {
        final globalPosition = details.globalPosition;
        final angle = _calcAngle(context, globalPosition);
        _updateVolume(angle);
      },
      child: Transform.rotate(
        angle: widget.value * math.pi * 2,
        child: widget.child ?? VolumeKnob(knobSize: widget.size ?? 200),
      ),
    );
  }
}

class VolumeKnob extends StatelessWidget {
  final double knobSize;
  const VolumeKnob({super.key, required this.knobSize});

  @override
  Widget build(BuildContext context) {
    return Container(
        key: key,
        width: knobSize,
        height: knobSize,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blueGrey[300]!, width: 0.5),
          gradient: RadialGradient(
            center: const Alignment(0, -0.2),
            colors: [Colors.blueGrey[400]!, Colors.blueGrey[600]!],
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 2,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Align(
          alignment: const Alignment(0, -0.9),
          child: Container(
            width: knobSize * 0.09,
            height: knobSize * 0.09,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 0.5),
              color: Colors.grey[300],
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 2,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Center(
              child: Container(
                width: knobSize * 0.05,
                height: knobSize * 0.05,
                decoration: BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 1.0,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
