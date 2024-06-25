import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ui_playground_134/pages/deform_cloud/deform_cloud_widget.dart';
import 'package:ui_playground_134/utils/github_link.dart';

class DeformCloudExample extends StatefulWidget {
  final String githubUrl;
  const DeformCloudExample({super.key, required this.githubUrl});

  @override
  State<DeformCloudExample> createState() => _DeformCloudExampleState();
}

class _DeformCloudExampleState extends State<DeformCloudExample> {
  bool showBaseLine = false;
  int waveCount = 30;
  double waveRadius = 10;
  double touchStrength = 1;
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final h = MediaQuery.sizeOf(context).height;

    return Scaffold(
        backgroundColor: Colors.blue.shade300,
        appBar: AppBar(
          actions: [
            IconButton(
                icon: const FaIcon(FontAwesomeIcons.github),
                onPressed: () async {
                  await GithubLink.openGithubLink(widget.githubUrl);
                })
          ],
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(height: 50),
                DeformCloudWidget(
                  waveCount: waveCount,
                  color: Colors.blue.shade50,
                  width: w * 0.8,
                  height: h * 0.3,
                  waveRadius: waveRadius,
                  touchStrength: touchStrength,
                  isShowBaseLine: showBaseLine,
                  child: Center(
                    child: Text(
                      'Touch Me!',
                      style: TextStyle(
                        color: Colors.blue.shade200,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                SizedBox(
                  width: w * 0.8,
                  child: Column(
                    children: [
                      _buildAdjustSlider(
                        'Wave Count',
                        waveCount.toDouble(),
                        10,
                        30,
                        w,
                        (value) {
                          setState(() {
                            waveCount = value.toInt();
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildAdjustSlider('Wave Radius', waveRadius, 10, 50, w,
                          (value) {
                        setState(() {
                          waveRadius = value;
                        });
                      }),
                      const SizedBox(height: 16),
                      _buildAdjustSlider(
                        'Touch Strength',
                        touchStrength,
                        0.0,
                        3.0,
                        w,
                        (value) {
                          setState(() {
                            touchStrength = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      showBaseLine = !showBaseLine;
                    });
                  },
                  child: Text(
                    !showBaseLine ? 'Show Base Line' : 'Hide Base Line',
                  ),
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ));
  }

  Widget _buildAdjustSlider(String label, double value, double min, double max,
      double w, Function(double) onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(value.toStringAsFixed(1)),
              ),
            ],
          ),
        ),
        SizedBox(
          width: w * 0.6,
          child: Slider(
            min: min,
            max: max,
            value: value,
            onChanged: (value) {
              onChanged(value);
            },
          ),
        ),
      ],
    );
  }
}
