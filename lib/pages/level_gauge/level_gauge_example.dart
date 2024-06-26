import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ui_playground_134/pages/level_gauge/level_gauge_widget.dart';
import 'package:ui_playground_134/utils/github_link.dart';

class LevelGaugeExample extends StatefulWidget {
  final String githubUrl;
  const LevelGaugeExample({super.key, required this.githubUrl});

  @override
  State<LevelGaugeExample> createState() => _LevelGaugeExampleState();
}

class _LevelGaugeExampleState extends State<LevelGaugeExample>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _showData = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              icon: const FaIcon(FontAwesomeIcons.github),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              onPressed: () async {
                await GithubLink.openGithubLink(widget.githubUrl);
              })
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Container(
                width: 300,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (_animationController.status ==
                            AnimationStatus.forward) {
                          return;
                        }
                        _animationController.reset();
                        _animationController.forward();
                      },
                      child: const Text('Animate'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _showData = !_showData;
                        });
                      },
                      child: Text(_showData ? 'hide data' : 'show data'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              _showData
                  ? const Text("value: 5000,range: 0~10000, target: 3000",
                      style: TextStyle(fontSize: 20, color: Colors.grey))
                  : const SizedBox.shrink(),
              LevelGaugeWidget(
                width: 300,
                height: 150,
                value: 5000,
                minValue: 0,
                maxValue: 10000,
                targetValue: 3000,
                gaugeWidth: 20,
                backgroundColor: Colors.blue.shade300,
                textColor: Colors.blue.shade800,
                achievedColor: Colors.red.shade400,
                gaugeColor: Colors.blue.shade700,
                animationController: _animationController,
                textStyle: TextStyle(
                  fontSize: 32,
                  color: Colors.blue.shade700,
                ),
              ),
              const SizedBox(height: 18),
              _showData
                  ? const Text("value: 800,range: 0~1000, target: 700",
                      style: TextStyle(fontSize: 20, color: Colors.grey))
                  : const SizedBox.shrink(),
              LevelGaugeWidget(
                width: 150,
                height: 150,
                value: 800,
                minValue: 0,
                maxValue: 1000,
                targetValue: 700,
                gaugeWidth: 30,
                backgroundColor: Colors.amber.shade400,
                textColor: Colors.amber.shade900,
                achievedColor: Colors.red.shade900,
                gaugeColor: Colors.amber.shade800,
                animationController: _animationController,
                textStyle: TextStyle(
                  fontSize: 32,
                  color: Colors.amber.shade700,
                ),
              ),
              const SizedBox(height: 18),
              _showData
                  ? const Text("value: 40,range: 0~100, target: 70",
                      style: TextStyle(fontSize: 20, color: Colors.grey))
                  : const SizedBox.shrink(),
              LevelGaugeWidget(
                width: 500.0.clamp(0, w),
                height: 150,
                value: 40,
                minValue: 0,
                maxValue: 100,
                targetValue: 70,
                gaugeWidth: 40,
                padding: 8,
                backgroundColor: Colors.green.shade300,
                textColor: Colors.green.shade800,
                achievedColor: Colors.red.shade400,
                gaugeColor: Colors.green.shade700,
                animationController: _animationController,
                textStyle: TextStyle(
                  fontSize: 32,
                  color: Colors.green.shade700,
                ),
              ),
              const SizedBox(height: 18),
            ],
          ),
        ),
      ),
    );
  }
}
