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
  const LevelGaugeWidget(
      {super.key,
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
      this.textStyle});

  @override
  State<LevelGaugeWidget> createState() => _LevelGaugeWidgetState();
}

class _LevelGaugeWidgetState extends State<LevelGaugeWidget>
    with SingleTickerProviderStateMixin {
  late double _paddingValue;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animation = Tween<double>(begin: 0, end: widget.value).animate(
        CurvedAnimation(
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
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  width: widget.width - _paddingValue * 3 - widget.gaugeWidth,
                  height: widget.height - _paddingValue * 3 - widget.gaugeWidth,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(_paddingValue * 0.7),
                  ),
                  child: Center(
                      child: Text(
                    widget.value.toString(),
                    style: widget.textStyle,
                  )),
                ),
              ),
              AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return CustomPaint(
                    painter: GaugePainter(
                      value: _animation.value,
                      minValue: widget.minValue,
                      maxValue: widget.maxValue,
                      targetValue: widget.targetValue,
                      gaugeWidth: widget.gaugeWidth,
                      gaugeColor: widget.gaugeColor,
                      achievedColor: widget.achievedColor,
                    ),
                    child: Container(),
                  );
                },
              )
            ],
          ),
        ),
      ],
    );
  }
}

class GaugePainter extends CustomPainter {
  final double value;
  final double minValue;
  final double maxValue;
  final double targetValue;
  final double gaugeWidth;
  final Color gaugeColor;
  final Color achievedColor;

  const GaugePainter(
      {required this.value,
      required this.minValue,
      required this.maxValue,
      required this.targetValue,
      required this.gaugeWidth,
      required this.gaugeColor,
      required this.achievedColor});

  double _calcGaugeLength(Size size, double percent) {
    final baseHorizontalLength = size.width - gaugeWidth;
    final baseVerticalLength = size.height - gaugeWidth;
    final baseLength = baseHorizontalLength + baseVerticalLength;
    return baseLength * percent;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final percent = (value - minValue) / (maxValue - minValue);

    final basePaint = Paint();
    basePaint.color = Color.lerp(Colors.white, gaugeColor, 0.1) ?? gaugeColor;
    basePaint.strokeCap = StrokeCap.round;
    basePaint.strokeJoin = StrokeJoin.round;
    basePaint.strokeWidth = gaugeWidth;
    basePaint.style = PaintingStyle.stroke;

    final gaugePaint = Paint();
    gaugePaint.color = value > targetValue ? achievedColor : gaugeColor;
    gaugePaint.strokeCap = StrokeCap.round;
    gaugePaint.strokeJoin = StrokeJoin.round;
    gaugePaint.strokeWidth = gaugeWidth;
    gaugePaint.style = PaintingStyle.stroke;

    final basePath = Path();
    basePath.moveTo(0 + gaugeWidth / 2, size.height - gaugeWidth / 2);
    basePath.lineTo(size.width - gaugeWidth / 2, size.height - gaugeWidth / 2);
    basePath.lineTo(size.width - gaugeWidth / 2, 0 + gaugeWidth / 2);

    final gaugeLength = _calcGaugeLength(size, percent);

    final pathMetrics = basePath.computeMetrics().first;
    final partialPath =
        pathMetrics.extractPath(0, pathMetrics.length * percent);

    final gaugePath = Path();
    gaugePath.moveTo(0 + gaugeWidth / 2, size.height - gaugeWidth / 2);
    gaugePath.lineTo(gaugeLength.clamp(0, size.width - gaugeWidth / 2),
        size.height - gaugeWidth / 2);
    gaugePath.lineTo(
        size.width - gaugeWidth / 2,
        (gaugeLength - size.width - gaugeWidth / 2)
            .clamp(0, 0 + gaugeWidth / 2));

    canvas.drawPath(basePath, basePaint);
    canvas.drawPath(partialPath, gaugePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
