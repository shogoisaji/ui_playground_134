import 'package:flutter/material.dart';

class DragActionWidget extends StatefulWidget {
  final Widget initialWidget;
  final Widget appliedWidget;
  final double width;
  final double height;
  final Offset initialPosition;
  final Offset targetPosition;
  final double intoArea;
  final double initialAngle;
  final Color bgColor;
  final bool isAccepted;
  final VoidCallback onAccepted;
  const DragActionWidget(
      {super.key,
      required this.initialWidget,
      required this.appliedWidget,
      required this.width,
      required this.height,
      required this.initialPosition,
      required this.targetPosition,
      required this.intoArea,
      required this.initialAngle,
      this.bgColor = Colors.grey,
      required this.isAccepted,
      required this.onAccepted});

  @override
  State<DragActionWidget> createState() => _DragActionWidgetState();
}

class _DragActionWidgetState extends State<DragActionWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<Offset> positionAnimation;

  OverlayEntry? _overlay;

  double _distance = 0;
  double _angle = 0.0;
  double _initialDistance = 0;

  bool _isIntoArea = false;
  bool _isDragging = false;

  late Offset _position;

  void _setAnimation(Offset start, Offset end) {
    positionAnimation = Tween<Offset>(begin: start, end: end).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeOutBack,
      ),
    );
  }

  void _updateAngle() {
    final nextAngle = widget.initialAngle * (_distance / _initialDistance);
    setState(() {
      if (widget.initialAngle > 0) {
        _angle = nextAngle.clamp(0, widget.initialAngle);
      } else {
        _angle = nextAngle.clamp(widget.initialAngle, 0);
      }
    });
    if (_distance < widget.intoArea) {
      setState(() {
        _isIntoArea = true;
      });
    } else {
      setState(() {
        _isIntoArea = false;
      });
    }
  }

  void _backInitialPosition() {
    _setAnimation(
      _position,
      widget.initialPosition,
    );
    controller.reset();
    controller.forward();
  }

  void _handlePanStart() {
    setState(() {
      _isDragging = true;
    });
    final double topPadding = MediaQuery.of(context).padding.top;
    final double appBarHeight = AppBar().preferredSize.height;
    _overlay = OverlayEntry(
      builder: (context) {
        return AnimatedBuilder(
          animation: positionAnimation,
          builder: (context, child) {
            return Positioned(
              top: _position.dy -
                  widget.height / 2 +
                  (topPadding + appBarHeight),
              left: _position.dx - widget.width / 2,
              child: Transform.rotate(
                angle: _angle,
                child: Material(
                  color: Colors.transparent,
                  child: _cardWidget(
                    _isIntoArea ? widget.appliedWidget : widget.initialWidget,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
    Overlay.of(context).insert(_overlay!);
  }

  void _dragEnd() {
    _overlay?.remove();
    _overlay = null;
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    setState(() {
      _position = Offset(
        _position.dx + details.delta.dx,
        _position.dy + details.delta.dy,
      );
      _distance = (widget.targetPosition - _position).distance;
    });
    _updateAngle();
    _overlay?.markNeedsBuild();
  }

  void _handlePanEnd(DragEndDetails details) async {
    if (_isIntoArea) {
      widget.onAccepted();
      _setAnimation(_position, widget.targetPosition);
    } else {
      _setAnimation(_position, widget.initialPosition);
    }
    controller.reset();
    await controller.forward();
    _dragEnd();
    setState(() {
      _isDragging = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _position = widget.initialPosition;
    controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    controller.addListener(() {
      setState(() {
        _position = positionAnimation.value;
      });
      _distance = (widget.targetPosition - _position).distance;
      _updateAngle();
    });
    _initialDistance =
        (widget.targetPosition - widget.initialPosition).distance;
    _distance = (widget.targetPosition - _position).distance;
    _setAnimation(widget.initialPosition, widget.targetPosition);
    _updateAngle();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(DragActionWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isAccepted != oldWidget.isAccepted && !widget.isAccepted) {
      _backInitialPosition();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: _position.dy - widget.height / 2,
          left: _position.dx - widget.width / 2,
          child: GestureDetector(
            onPanStart: (details) {
              _handlePanStart();
            },
            onPanUpdate: (details) {
              _handlePanUpdate(details);
            },
            onPanEnd: (details) {
              _handlePanEnd(details);
            },
            child: Transform.rotate(
              angle: _angle,
              child: Opacity(
                opacity: _isDragging ? 0 : 1,
                child: _cardWidget(
                  widget.isAccepted
                      ? widget.appliedWidget
                      : widget.initialWidget,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _cardWidget(Widget child) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: widget.bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: child,
    );
  }
}
