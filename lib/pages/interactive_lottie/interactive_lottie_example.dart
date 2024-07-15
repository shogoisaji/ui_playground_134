import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:ui_playground_134/pages/interactive_lottie/lottie_animation_controller.dart';
import 'package:ui_playground_134/utils/open_link.dart';

class InteractiveLottieExample extends StatefulWidget {
  final String githubUrl;
  const InteractiveLottieExample({super.key, required this.githubUrl});

  @override
  State<InteractiveLottieExample> createState() =>
      _InteractiveLottieExampleState();
}

class _InteractiveLottieExampleState extends State<InteractiveLottieExample>
    with TickerProviderStateMixin {
  late LottieAnimationController _lottieController;
  late AnimationController _baseAnimationController;

  final ValueNotifier<bool> _isSending = ValueNotifier<bool>(false);

  final Map<String, Map<String, double>> animationList = {
    'send': const {'start': 1.0, 'end': 1.6},
    'loop': const {'start': 0.0, 'end': 1.0},
    'load': const {'start': 4.1, 'end': 6.0},
    'done': const {'start': 2.0, 'end': 3.0},
  };

  void _sendAnimation() async {
    await _lottieController.pointForward(
        animationList['send']!['start']!, animationList['send']!['end']!);
    _lottieController.pointLoop(
        animationList['load']!['start']!, animationList['load']!['end']!);
    await Future.delayed(const Duration(milliseconds: 4000));
    await _lottieController.pointForward(
        animationList['done']!['start']!, animationList['done']!['end']!);
    await Future.delayed(const Duration(milliseconds: 1000));
    _lottieController.value = 0.0;
    _isSending.value = false;
  }

  @override
  void initState() {
    super.initState();
    _lottieController = LottieAnimationController(
      animationRangeSeconds: 6.0,
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _baseAnimationController = AnimationController(
      vsync: this,
    );

    _isSending.addListener(() {
      if (_isSending.value) {
        _sendAnimation();
      }
    });
  }

  @override
  void dispose() {
    _lottieController.dispose();
    _baseAnimationController.dispose();
    _isSending.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade300,
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
            children: [
              const SizedBox(
                height: 50,
              ),
              Text(
                'Interactive Lottie',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade900,
                ),
              ),
              _interactiveLottie(),
              const SizedBox(
                height: 100,
              ),
              _baseLottie(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _interactiveLottie() {
    return MouseRegion(
      onEnter: (_) {
        _lottieController.pointLoop(
            animationList['loop']!['start']!, animationList['loop']!['end']!);
      },
      onExit: (_) {
        if (_isSending.value) return;
        _lottieController.value = 0.0;
      },
      child: GestureDetector(
        onTap: () {
          _isSending.value = true;
          _sendAnimation();
        },
        child: Lottie.asset(
          'assets/lottie/send.json',
          controller: _lottieController,
          onLoaded: (composition) {
            _lottieController.duration = composition.duration;
          },
        ),
      ),
    );
  }

  Widget _baseLottie() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.green.shade200,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.green.shade900,
        ),
      ),
      child: Column(
        children: [
          Text(
            'Base Lottie',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.green.shade900,
            ),
          ),
          Lottie.asset(
            'assets/lottie/send.json',
            controller: _baseAnimationController,
            onLoaded: (composition) {
              _baseAnimationController
                ..duration = composition.duration
                ..repeat();
            },
          ),
          AnimatedBuilder(
            animation: _baseAnimationController,
            builder: (context, child) {
              return SizedBox(
                height: 20,
                width: 200,
                child: Row(
                  children: [
                    Expanded(
                      flex: (_baseAnimationController.value * 1000).toInt(),
                      child: Container(
                        color: Colors.green.shade900,
                      ),
                    ),
                    Expanded(
                      flex:
                          ((1 - _baseAnimationController.value) * 1000).toInt(),
                      child: Container(
                        color: Colors.green.shade50,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
