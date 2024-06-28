import 'package:flutter/material.dart';
import 'package:ui_playground_134/pages/m_line_chart/chart_data.dart';
import 'package:ui_playground_134/strings.dart';

class ChartWidget extends StatefulWidget {
  final double width;
  final double height;
  final List<ChartData> data;
  const ChartWidget({
    super.key,
    required this.width,
    required this.height,
    required this.data,
  });

  @override
  State<ChartWidget> createState() => _ChartWidgetState();
}

class _ChartWidgetState extends State<ChartWidget> {
  ChartData maxChartData = ChartData(date: DateTime.now(), value: 0);
  ChartData minChartData = ChartData(date: DateTime.now(), value: 0);

  int _selectedIndex = 0;

  void initializeData() {
    /// 最大値、最小値をセット
    final nonNullData = widget.data.where((item) => item.value != null);
    maxChartData = nonNullData
        .reduce((max, item) => item.value! > max.value! ? item : max);
    minChartData = nonNullData
        .reduce((min, item) => item.value! < min.value! ? item : min);

    /// indexの初期値をセット
    _selectedIndex = widget.data.length ~/ 2;
  }

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade600,
        borderRadius: BorderRadius.circular(15),
      ),
      child: GestureDetector(
        onPanUpdate: (details) {
          final oneSpan = (widget.width - 20) / widget.data.length;
          final newIndex = (details.localPosition.dx ~/ oneSpan).clamp(
            0,
            widget.data.length - 1,
          );
          setState(() {
            _selectedIndex = newIndex;
          });
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade800,
            borderRadius: BorderRadius.circular(10),
          ),
          child: CustomPaint(
            painter: ChartPainter(
              data: widget.data.take(150).toList(),
              maxValue: maxChartData.value!,
              minValue: minChartData.value!,
              selectedIndex: _selectedIndex,
            ),
          ),
        ),
      ),
    );
  }
}

class ChartPainter extends CustomPainter {
  final List<ChartData> data;
  final double maxValue;
  final double minValue;
  final double underOffset;
  final double upperOffset;
  final int selectedIndex;
  const ChartPainter({
    required this.data,
    required this.maxValue,
    required this.minValue,
    this.underOffset = 100.0,
    this.upperOffset = 70.0,
    required this.selectedIndex,
  });

  Path _createChartPath(Size size) {
    final spanWidth = size.width / (data.length - 1);
    final path = Path();
    for (int i = 0; i < data.length; i++) {
      final x = spanWidth * i;
      final y = size.height -
          (size.height - underOffset - upperOffset) *
              (data[i].value! - minValue) /
              (maxValue - minValue) -
          underOffset;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    return path;
  }

  void _paintChart(Canvas canvas, Size size, Path chartPath, double maskWidth) {
    final paint = Paint();
    paint.color = Colors.blue.shade300;
    paint.strokeWidth = 2;
    final basePaint = Paint();
    basePaint.color = Colors.grey;
    basePaint.strokeWidth = 2;
    canvas.drawPath(chartPath, basePaint);

    final maskPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, maskWidth, size.height));
    canvas.save();
    canvas.clipPath(maskPath);
    canvas.drawPath(chartPath, paint);
    canvas.restore();
  }

  void _paintChartFill(
      Canvas canvas, Size size, Path chartPath, double maskWidth) {
    final chartFillPath = Path.from(chartPath); // Path.fromでpathをコピー
    chartFillPath.lineTo(size.width, size.height);
    chartFillPath.lineTo(0, size.height);
    chartFillPath.close();

    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Colors.blue.withOpacity(0.5),
        Colors.blue.withOpacity(0.0),
      ],
    );
    final fillPaint = Paint()
      ..shader =
          gradient.createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final maskPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, maskWidth, size.height));
    canvas.save();
    canvas.clipPath(maskPath);
    canvas.drawPath(chartFillPath, fillPaint);
    canvas.restore();
  }

  void _paintPartition(
      Canvas canvas, Size size, Path chartPath, double partitionPositionX) {
    final partitionPaint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // 点線を描画
    const dashWidth = 5;
    const dashSpace = 5;
    double startY = 60;
    while (startY < size.height) {
      canvas.drawLine(
        Offset(partitionPositionX, startY),
        Offset(partitionPositionX, startY + dashWidth),
        partitionPaint,
      );
      startY += dashWidth + dashSpace;
    }
  }

  void _paintText(Canvas canvas, Size size, double partitionPositionX) {
    final textPainter = TextPainter(
      text: TextSpan(
        children: [
          TextSpan(
            text: '￥${(data[selectedIndex].value ?? 0).toStringAsFixed(0)}\n',
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
          TextSpan(
            text: data[selectedIndex].date.toIso8601String().toYMDString(),
            style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
          ),
        ],
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    textPainter.layout();
    final position = partitionPositionX - textPainter.width / 2;
    const double textPadding = 10.0;

    final double textPositionX = position < textPadding
        ? textPadding
        : position > size.width - textPainter.width - textPadding
            ? size.width - textPainter.width - textPadding
            : position;

    textPainter.paint(canvas, Offset(textPositionX, 10));
  }

  @override
  void paint(Canvas canvas, Size size) {
    final partitionPositionX = selectedIndex * size.width / (data.length - 1);
    if (size.height <= (underOffset + upperOffset)) {
      throw Exception('高さはunderOffset + upperOffsetより大きくなければなりません');
    }

    final chartPath = _createChartPath(size);

    _paintChartFill(canvas, size, chartPath, partitionPositionX);
    _paintChart(canvas, size, chartPath, partitionPositionX);
    _paintPartition(canvas, size, chartPath, partitionPositionX);
    _paintText(canvas, size, partitionPositionX);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
