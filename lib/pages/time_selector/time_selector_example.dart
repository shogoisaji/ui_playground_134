import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ui_playground_134/pages/time_selector/vertical_time_selector.dart';
import 'package:ui_playground_134/utils/open_link.dart';

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
      appBar: AppBar(
        actions: [
          IconButton(
              icon: const FaIcon(FontAwesomeIcons.github),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              onPressed: () async {
                await OpenLink.open(widget.githubUrl);
              })
        ],
      ),
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
