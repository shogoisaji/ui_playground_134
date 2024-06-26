import 'dart:ui';

import 'package:flutter/material.dart';

class FollowPathWidget extends StatefulWidget {
  const FollowPathWidget(
      {super.key,
      required this.path,
      required this.child,
      required this.isMove});
  final Path path;
  final Widget child;
  final bool isMove;

  @override
  State<FollowPathWidget> createState() => _FollowPathWidgetState();
}

class _FollowPathWidgetState extends State<FollowPathWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200));
    _animation = CurvedAnimation(parent: _controller, curve: CustomCurve());
    if (widget.isMove) {
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(FollowPathWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isMove == oldWidget.isMove) return;
    if (widget.isMove) {
      _controller.reset();
      _controller.forward();
    } else {
      _controller.reset();
    }
  }

  Offset getOffset(Path path, double progress, double childWidth) {
    List<PathMetric> pathMetrics = path.computeMetrics().toList();
    if (pathMetrics.isEmpty) {
      return Offset.zero;
    }
    double pathLength = pathMetrics.first.length;
    final distance = pathLength * progress;
    final Tangent? tangent = pathMetrics.first.getTangentForOffset(distance);
    final offset = tangent?.position;
    if (offset == null) {
      return Offset.zero;
    }
    return Offset(offset.dx - childWidth / 2, offset.dy + childWidth / 2);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset:
              getOffset(widget.path, (_animation.value).clamp(0.0, 1.0), 50),
          child: widget.child,
        );
      },
    );
  }
}

class CustomCurve extends Curve {
  final strength = 5.0;
  double _bounce(double t) {
    if (t < 1.2 / 2.75) {
      return 7.4 * t * t;
    } else if (t < 2.0 / 2.75) {
      t -= 1.05 / 2.75;
      return 7.4 * t * t + 0.95;
    } else if (t < 2.5 / 2.75) {
      t -= 1.5 / 2.75;
      return 7.4 * t * t + 0.97;
    }
    t -= 2.2 / 2.75;
    return 7.4 * t * t + 0.99;
  }

  @override
  double transformInternal(double t) {
    return _bounce(t);
  }
}
