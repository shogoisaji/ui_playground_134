import 'dart:math';

import 'package:flutter/material.dart';

class StripeAnimationWidget extends StatefulWidget {
  final Widget child;
  final AnimationController animationController;
  final double stripeWidth;
  final double maxStripeOffset;

  const StripeAnimationWidget({
    required this.child,
    required this.animationController,
    required this.stripeWidth,
    required this.maxStripeOffset,
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
    _initializeAnimation();
    _setupChildSizeMeasurement();
  }

  void _initializeAnimation() {
    _offsets =
        List.generate(stripeCountMaxLength, (_) => _generateRandomOffset());
    _animation = CurvedAnimation(
        parent: widget.animationController, curve: Curves.easeInQuad);
    widget.animationController.addStatusListener((status) {
      setState(() {
        _isAnimating = status != AnimationStatus.dismissed;
      });
    });
  }

  double _generateRandomOffset() {
    return (1 - Random().nextDouble() * 2) * widget.maxStripeOffset;
  }

  void _setupChildSizeMeasurement() {
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
    return _isAnimating ? _buildAnimatingWidget() : _buildStaticWidget();
  }

  Widget _buildStaticWidget() {
    return Container(
      key: _childKey,
      child: widget.child,
    );
  }

  Widget _buildAnimatingWidget() {
    return SizedBox(
      width: _childWidth,
      height: _childHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: List.generate(_stripeCount, (index) {
          final x = index * widget.stripeWidth;
          return AnimatedBuilder(
            animation: _animation,
            builder: (context, child) => _buildStripePosition(x, index),
          );
        }),
      ),
    );
  }

  Widget _buildStripePosition(double x, int index) {
    return Positioned(
      left: x,
      top: _offsets[index] * _animation.value,
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
