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
      backgroundColor: Colors.grey.shade700,
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
              const SizedBox(height: 18),
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
                      },
                      child: const Text('Reset'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _animationController.reset();
                        _animationController.forward();
                      },
                      child: const Text('Start'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
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
                gaugePoint: false,
              ),
              const SizedBox(height: 18),
              LevelGaugeWidget(
                width: 100,
                height: 150,
                value: 800,
                minValue: 200,
                maxValue: 1000,
                targetValue: 700,
                gaugeWidth: 7,
                backgroundColor: Colors.amber.shade400,
                textColor: Colors.amber.shade900,
                achievedColor: Colors.red.shade800,
                gaugeColor: Colors.amber.shade800,
                animationController: _animationController,
                textStyle: TextStyle(
                  fontSize: 32,
                  color: Colors.amber.shade700,
                ),
              ),
              const SizedBox(height: 18),
              LevelGaugeWidget(
                width: 400.0.clamp(0, w),
                height: 150,
                value: 4000,
                minValue: 0,
                maxValue: 10000,
                targetValue: 7000,
                gaugeWidth: 30,
                padding: 12,
                backgroundColor: Colors.green.shade300,
                textColor: Colors.green.shade800,
                achievedColor: Colors.red.shade400,
                gaugeColor: Colors.green.shade700,
                animationController: _animationController,
                textStyle: TextStyle(
                  fontSize: 48,
                  color: Colors.green.shade700,
                  fontWeight: FontWeight.w700,
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
