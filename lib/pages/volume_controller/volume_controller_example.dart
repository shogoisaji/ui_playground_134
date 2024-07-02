import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ui_playground_134/pages/volume_controller/volume_controller.dart';
import 'package:ui_playground_134/utils/open_link.dart';

class VolumeControllerExample extends StatefulWidget {
  final String githubUrl;
  const VolumeControllerExample({super.key, required this.githubUrl});

  @override
  State<VolumeControllerExample> createState() =>
      _VolumeControllerExampleState();
}

class _VolumeControllerExampleState extends State<VolumeControllerExample> {
  late double _currentValue;
  static const double minValue = 0.0;
  static const double maxValue = 1.3;
  static const double knobSize = 300.0;

  @override
  void initState() {
    super.initState();
    _currentValue = minValue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade300,
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
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 32),
              SizedBox(
                width: knobSize,
                height: knobSize,
                child: Stack(
                  children: [
                    Center(
                      child: VolumeController(
                        value: _currentValue,
                        size: knobSize,
                        minValue: minValue,
                        maxValue: maxValue,
                        hapticFeedbackSpan: 0.05,
                        onChanged: (value) {
                          setState(() {
                            _currentValue = value;
                          });
                        },
                      ),
                    ),
                    Center(
                        child: Text(
                      '${(_currentValue * 100).round()}',
                      style: TextStyle(
                        color: Colors.orange,
                        fontSize: 60,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                    )),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _buildGauge(_currentValue / (maxValue - minValue)),
              const SizedBox(height: 10),
              Text('Value: ${_currentValue.toStringAsFixed(2)}'),
              Text('Min: ${minValue.toStringAsFixed(2)}'),
              Text('Max: ${maxValue.toStringAsFixed(2)}'),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _currentValue = 0.0;
                  });
                },
                child: const Text('Reset'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGauge(double rate) {
    return Container(
      width: 200,
      height: 50,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade600,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Row(
          children: [
            Expanded(
              flex: (rate * 100).toInt(),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.orange,
                ),
              ),
            ),
            Expanded(
              flex: ((1 - rate) * 100).toInt(),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blueGrey.shade50,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
