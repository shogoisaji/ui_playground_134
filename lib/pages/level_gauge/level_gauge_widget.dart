import 'package:flutter/material.dart';

class LevelGaugeWidget extends StatefulWidget {
  final double width;
  final double height;
  final double value;
  final double minValue;
  final double maxValue;
  final double targetValue;
  final double gaugeWidth;
  final double? padding;
  final Color backgroundColor;
  final Color textColor;
  final Color achievedColor;
  final Color gaugeColor;
  final AnimationController animationController;
  final TextStyle? textStyle;
  final bool gaugePoint;
  const LevelGaugeWidget({
    super.key,
    required this.width,
    required this.height,
    required this.backgroundColor,
    required this.value,
    required this.minValue,
    required this.maxValue,
    required this.targetValue,
    required this.gaugeWidth,
    this.padding,
    required this.textColor,
    required this.achievedColor,
    required this.gaugeColor,
    required this.animationController,
    this.textStyle,
    this.gaugePoint = true,
  });

  @override
  State<LevelGaugeWidget> createState() => _LevelGaugeWidgetState();
}

class _LevelGaugeWidgetState extends State<LevelGaugeWidget>
    with SingleTickerProviderStateMixin {
  late double _paddingValue;
  late Animation<double> _animation;
  late Animation<double> _textAnimation;

  @override
  void initState() {
    super.initState();
    _animation = CurvedAnimation(
        parent: widget.animationController, curve: Curves.easeInOut);

    _textAnimation = Tween<double>(begin: widget.minValue, end: widget.value)
        .animate(CurvedAnimation(
            parent: widget.animationController, curve: Curves.easeInOut));

    _paddingValue =
        widget.padding != null ? widget.padding! : widget.width / 20;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: widget.width,
          height: widget.height,
          padding: EdgeInsets.all(_paddingValue),
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: BorderRadius.circular(_paddingValue),
          ),
          child: AnimatedBuilder(
            animation: widget.animationController,
            builder: (context, child) {
              return Stack(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      width:
                          widget.width - _paddingValue * 3 - widget.gaugeWidth,
                      height:
                          widget.height - _paddingValue * 3 - widget.gaugeWidth,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(_paddingValue * 0.7),
                      ),
                      child: Center(
                          child: Text(
                        _textAnimation.value.toStringAsFixed(0),
                        style: widget.textStyle,
                      )),
                    ),
                  ),
                  CustomPaint(
                    painter: GaugePainter(
                      animationValue: _animation,
                      value: widget.value,
                      minValue: widget.minValue,
                      maxValue: widget.maxValue,
                      targetValue: widget.targetValue,
                      gaugeWidth: widget.gaugeWidth,
                      gaugeColor: widget.gaugeColor,
                      achievedColor: widget.achievedColor,
                      cornerRadius: _paddingValue * 2,
                      showGaugePoint: widget.gaugePoint,
                    ),
                    child: Container(),
                  )
                ],
              );
            },
          ),
        )
      ],
    );
  }
}

class GaugePainter extends CustomPainter {
  final Animation<double> animationValue;
  final double value;
  final double minValue;
  final double maxValue;
  final double targetValue;
  final double gaugeWidth;
  final Color gaugeColor;
  final Color achievedColor;
  final double cornerRadius;
  final bool showGaugePoint;

  const GaugePainter(
      {required this.animationValue,
      required this.value,
      required this.minValue,
      required this.maxValue,
      required this.targetValue,
      required this.gaugeWidth,
      required this.gaugeColor,
      required this.achievedColor,
      required this.cornerRadius,
      required this.showGaugePoint});

  Path _createBasePath(Size size, double gaugeWidth, double cornerRadius) {
    final path = Path();
    final baseUnderHeight = size.height - gaugeWidth / 2;
    final baseRightWidth = size.width - gaugeWidth / 2;
    final p0 = Offset(0 + gaugeWidth / 2, baseUnderHeight);
    final p1 = Offset(baseRightWidth - cornerRadius, baseUnderHeight);
    final p2 = Offset(p1.dx + cornerRadius / 2, baseUnderHeight);
    final p3 = Offset(baseRightWidth, baseUnderHeight - cornerRadius / 2);
    final p4 = Offset(baseRightWidth, baseUnderHeight - cornerRadius);
    final p5 = Offset(baseRightWidth, 0 + gaugeWidth / 2);
    path.moveTo(p0.dx, p0.dy);
    path.lineTo(p1.dx, p1.dy);
    path.cubicTo(p2.dx, p2.dy, p3.dx, p3.dy, p4.dx, p4.dy);
    path.lineTo(p5.dx, p5.dy);
    return path;
  }

  Paint _createPaint(Color color) {
    final paint = Paint();
    paint.color = color;
    paint.strokeCap = StrokeCap.round;
    paint.strokeJoin = StrokeJoin.round;
    paint.strokeWidth = gaugeWidth;
    paint.style = PaintingStyle.stroke;
    return paint;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final normalizedValue = (value - minValue) / (maxValue - minValue);
    final gaugeProgressPercent = normalizedValue * animationValue.value;
    final targetPercent = (targetValue - minValue) / (maxValue - minValue);

    final basePaint =
        _createPaint(Color.lerp(Colors.white, gaugeColor, 0.1) ?? Colors.white);

    final targetPaint =
        _createPaint(Color.lerp(Colors.white, gaugeColor, 0.3) ?? Colors.white);

    final gaugePaint = _createPaint(value * animationValue.value > targetValue
        ? achievedColor
        : gaugeColor);

    final gaugePointPaint = _createPaint(
        value * animationValue.value > targetValue
            ? Color.lerp(Colors.black, achievedColor, 0.8) ?? achievedColor
            : Color.lerp(Colors.black, gaugeColor, 0.8) ?? gaugeColor);

    final basePath = _createBasePath(size, gaugeWidth, cornerRadius);

    final pathMetrics = basePath.computeMetrics().first;
    final gaugePoint = pathMetrics.extractPath(
        pathMetrics.length * gaugeProgressPercent,
        pathMetrics.length * gaugeProgressPercent);
    final gaugePath =
        pathMetrics.extractPath(0, pathMetrics.length * gaugeProgressPercent);
    final targetPath =
        pathMetrics.extractPath(0, pathMetrics.length * targetPercent);

    canvas.drawPath(basePath, basePaint);
    canvas.drawPath(targetPath, targetPaint);
    canvas.drawPath(gaugePath, gaugePaint);
    if (showGaugePoint) {
      canvas.drawPath(gaugePoint, gaugePointPaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
