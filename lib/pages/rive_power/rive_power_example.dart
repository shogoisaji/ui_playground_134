import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ui_playground_134/pages/rive_power/rive_widget.dart';
import 'package:ui_playground_134/utils/open_link.dart';

class RivePowerExample extends StatefulWidget {
  final String githubUrl;
  const RivePowerExample({super.key, required this.githubUrl});

  @override
  State<RivePowerExample> createState() => _RivePowerExampleState();
}

class _RivePowerExampleState extends State<RivePowerExample>
    with SingleTickerProviderStateMixin {
  static const _riveLink =
      "https://rive.app/community/files/11414-21800-power-on";

  late AnimationController _animationController;
  double _shineValue = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _animationController.addListener(() {
      setState(() {
        _shineValue = _animationController.value * 100;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade500,
      appBar: AppBar(
        actions: [
          IconButton(
              icon: SvgPicture.asset(
                "assets/images/rive_icon.svg",
                width: 24,
                height: 24,
                colorFilter:
                    ColorFilter.mode(Colors.grey.shade800, BlendMode.srcIn),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              onPressed: () async {
                await OpenLink.open(_riveLink);
              }),
          IconButton(
              icon: const FaIcon(FontAwesomeIcons.github),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              onPressed: () async {
                await OpenLink.open(widget.githubUrl);
              }),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 12),
              Text(
                'Press ↓',
                style: TextStyle(
                  color: Colors.blueGrey.shade100,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTapDown: (_) {
                  _animationController.forward();
                },
                onTapUp: (_) {
                  if (_animationController.value >= 1.0) return;
                  _animationController.reverse();
                },
                child: RiveWidget(
                  shineValue: _shineValue,
                ),
              ),
              const SizedBox(height: 24),
              _animationController.value >= 1.0
                  ? ElevatedButton(
                      onPressed: () {
                        _animationController.reset();
                        setState(() {
                          _shineValue = 0.0;
                        });
                      },
                      child: const Text('OFF'),
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
