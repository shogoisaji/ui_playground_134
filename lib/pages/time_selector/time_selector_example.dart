import 'package:flutter/material.dart';
import 'package:ui_playground_134/pages/time_selector/vertical_time_selector.dart';

class TimeSelectorExample extends StatefulWidget {
  final String githubUrl;
  const TimeSelectorExample({super.key, required this.githubUrl});

  @override
  State<TimeSelectorExample> createState() => _TimeSelectorExampleState();
}

class _TimeSelectorExampleState extends State<TimeSelectorExample> {
  int _hour = 0;
  int _minute = 0;

  final VerticalTimeSelector _timeSelector = VerticalTimeSelector();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade700,
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
                '${_hour.toString().padLeft(2, '0')}:${_minute.toString().padLeft(2, '0')}',
                style: TextStyle(color: Colors.grey.shade100, fontSize: 32)),
            ElevatedButton(
              onPressed: () async {
                final result = await _timeSelector.show(context);
                if (result != null) {
                  setState(() {
                    _hour = result.$1;
                    _minute = result.$2;
                  });
                }
              },
              child: const Text('Time Selector'),
            ),
          ],
        ),
      ),
    );
  }
}

class TimeIndicatorPainter extends CustomPainter {
  final int value;
  final int numberOfDivision;
  final double paddingValue;
  final double textSize;
  final Color color;
  const TimeIndicatorPainter(
      {required this.value,
      required this.numberOfDivision,
      required this.color,
      this.paddingValue = 20.0,
      this.textSize = 32.0});

  double _calcHeight(int index, Size size) {
    return index * (size.height - paddingValue * 2) / numberOfDivision +
        paddingValue;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final double normalLength = size.width / 4;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 1.0;
    final accentPaint = Paint()
      ..color = Colors.yellow
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2;

    for (var i = 0; i < numberOfDivision; i++) {
      final path = Path();
      path.moveTo(size.width - 20, _calcHeight(i, size));
      final length = switch (i) {
        _ when i == value => -normalLength * 1.8,
        _ when (i - value).abs() == 1 => -normalLength * 1.4,
        _ when (i - value).abs() == 2 => -normalLength * 1.2,
        _ => -normalLength,
      };
      path.relativeLineTo(length, 0);
      canvas.drawPath(
          path, i % (numberOfDivision ~/ 4) == 0 ? accentPaint : paint);
    }

    final textPainter = TextPainter(
      text: TextSpan(
        text: value.toString().padLeft(2, '  '),
        style: TextStyle(fontSize: textSize, color: color),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(minWidth: size.width);
    textPainter.paint(
        canvas, Offset(0, _calcHeight(value, size) - textPainter.height / 2));

    for (var i = 0; i < 4 + 1; i++) {
      final textPainter = TextPainter(
        text: TextSpan(
          text: (numberOfDivision / 4 * i).toString(),
          style: TextStyle(fontSize: 16, color: color.withOpacity(0.5)),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
          canvas,
          Offset(
              size.width - textPainter.width,
              _calcHeight(numberOfDivision ~/ 4 * i, size) -
                  textPainter.height / 2));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
