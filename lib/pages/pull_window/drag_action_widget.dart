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

  double distance = 0;
  double angle = 0.0;
  double initialDistance = 0;

  bool isIntoArea = false;

  late Offset position;

  void setAnimation(Offset start, Offset end) {
    positionAnimation = Tween<Offset>(begin: start, end: end).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeOutBack,
      ),
    );
  }

  void updateAngle() {
    final nextAngle = widget.initialAngle * (distance / initialDistance);
    setState(() {
      if (widget.initialAngle > 0) {
        angle = nextAngle.clamp(0, widget.initialAngle);
      } else {
        angle = nextAngle.clamp(widget.initialAngle, 0);
      }
    });
    if (distance < widget.intoArea) {
      setState(() {
        isIntoArea = true;
      });
    } else {
      setState(() {
        isIntoArea = false;
      });
    }
  }

  void backInitialPosition() {
    setAnimation(
      position,
      widget.initialPosition,
    );
    controller.reset();
    controller.forward();
  }

  @override
  void initState() {
    super.initState();
    position = widget.initialPosition;
    controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    controller.addListener(() {
      setState(() {
        position = positionAnimation.value;
      });
      distance = (widget.targetPosition - position).distance;
      updateAngle();
    });
    initialDistance = (widget.targetPosition - widget.initialPosition).distance;
    distance = (widget.targetPosition - position).distance;
    setAnimation(widget.initialPosition, widget.targetPosition);
    updateAngle();
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
      backInitialPosition();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedBuilder(
          animation: positionAnimation,
          builder: (context, child) {
            return Positioned(
              top: position.dy - widget.height / 2,
              left: position.dx - widget.width / 2,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    position = Offset(
                      position.dx + details.delta.dx,
                      position.dy + details.delta.dy,
                    );
                    distance = (widget.targetPosition - position).distance;
                  });
                  updateAngle();
                },
                onPanEnd: (details) {
                  if (isIntoArea) {
                    widget.onAccepted();
                    setAnimation(position, widget.targetPosition);
                  } else {
                    setAnimation(position, widget.initialPosition);
                  }
                  controller.reset();
                  controller.forward();
                },
                child: Transform.rotate(
                  angle: angle,
                  child: _cardWidget(
                    isIntoArea ? widget.appliedWidget : widget.initialWidget,
                  ),
                ),
              ),
            );
          },
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
