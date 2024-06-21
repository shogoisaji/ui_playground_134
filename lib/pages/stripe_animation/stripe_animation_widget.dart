import 'dart:math';

import 'package:flutter/material.dart';

class StripeAnimationWidget extends StatefulWidget {
  final Widget child;
  final AnimationController animationController;
  final double stripeWidth;
  final double moveRange;

  const StripeAnimationWidget({
    required this.child,
    required this.animationController,
    required this.stripeWidth,
    required this.moveRange,
    super.key,
  });

  @override
  _StripeAnimationWidgetState createState() => _StripeAnimationWidgetState();
}

class _StripeAnimationWidgetState extends State<StripeAnimationWidget> {
  static const stripeCountMaxLength = 100;
  final GlobalKey _childKey = GlobalKey();

  late Animation<double> _animation;
  late int _stripeCount;
  late List<double> _offsets;
  late double _childWidth;
  late double _childHeight;

  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();

    /// Set Random Move Amount
    _offsets = List.generate(stripeCountMaxLength, (_) {
      final rand = 1 - Random().nextDouble() * 2; // -1.0 ~ 1.0
      return rand * widget.moveRange;
    });

    _animation = CurvedAnimation(
        parent: widget.animationController, curve: Curves.easeInQuad);

    widget.animationController.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
        setState(() {
          _isAnimating = false;
        });
      } else {
        setState(() {
          _isAnimating = true;
        });
      }
    });

    /// Get the size of a child widget from a global key
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_childKey.currentContext == null) return;
      final RenderBox renderBox =
          _childKey.currentContext!.findRenderObject() as RenderBox;
      setState(() {
        _childWidth = renderBox.size.width;
        _childHeight = renderBox.size.height;
        _stripeCount = (_childWidth ~/ widget.stripeWidth) + 1;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return !_isAnimating
        ? Container(
            key: _childKey,
            child: widget.child,
          )
        : SizedBox(
            width: _childWidth,
            height: _childHeight,
            child: Stack(
              clipBehavior: Clip.none,
              children: List.generate(_stripeCount, (i) {
                final x = i * widget.stripeWidth;
                return AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Positioned(
                      left: x,
                      top: _offsets[i] * _animation.value,
                      child: ClipRect(
                        clipper: RectCustomClipper(
                          rectSize: Size(widget.stripeWidth, _childHeight),
                        ),
                        child: Opacity(
                          opacity: (1 - _animation.value).clamp(0.0, 1.0),
                          child: Transform.translate(
                            offset: Offset(-x, 0),
                            child: widget.child,
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          );
  }
}

class RectCustomClipper extends CustomClipper<Rect> {
  final Size rectSize;
  const RectCustomClipper({required this.rectSize});

  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(0, 0, rectSize.width, rectSize.height);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return false;
  }
}
