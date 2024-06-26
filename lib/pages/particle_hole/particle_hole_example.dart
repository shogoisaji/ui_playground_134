import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ui_playground_134/utils/github_link.dart';

class ParticleHoleExample extends StatefulWidget {
  final String githubUrl;
  const ParticleHoleExample({super.key, required this.githubUrl});

  @override
  State<ParticleHoleExample> createState() => _ParticleHoleExampleState();
}

class _ParticleHoleExampleState extends State<ParticleHoleExample>
    with TickerProviderStateMixin {
  static const double _initialHoleRadius = 20;

  late AnimationController _appearAnimationController;
  late Animation<double> _appearAnimation;
  late AnimationController _holeScaleAnimationController;
  late Animation<double> _holeScaleAnimation;
  late Ticker _ticker;
  late double _holeRadius;

  final List<Particle> particles = [];

  double _particleRadius = 0;
  Offset position = const Offset(0, 0);

  Offset _calcHoleCenterPosition(
      double width, double height, double animationValue) {
    return Offset(width / 2, height / 2 * animationValue);
  }

  @override
  void initState() {
    super.initState();

    _holeRadius = _initialHoleRadius;

    _appearAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 3000));
    _appearAnimation = CurvedAnimation(
        parent: _appearAnimationController, curve: Curves.easeOutQuart);

    /// initial animation
    Future.delayed(const Duration(milliseconds: 500), () {
      _appearAnimationController.forward();
    });

    _holeScaleAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2000));
    _holeScaleAnimation = CurvedAnimation(
        parent: _holeScaleAnimationController, curve: Curves.easeInOut);

    _ticker = createTicker((_) {
      for (var i = 0; i < 30; i++) {
        particles.add(Particle(holeRadius: _particleRadius));
      }
      for (var particle in particles) {
        particle.move();
      }

      /// particle opacityが0になったパーティクルを削除
      particles.removeWhere((particle) => particle.particleRadius <= 0);
      setState(() {});
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final size = MediaQuery.sizeOf(context);
      _holeScaleAnimation.addListener(() {
        const initialRadius = 2.5;
        const scaleRate = 6;
        setState(() {
          /// particle radius update
          _particleRadius =
              _holeScaleAnimation.value * scaleRate + initialRadius;

          /// hole radius update
          _holeRadius = size.width > size.height
              ? (size.width + 100) / 2 * _holeScaleAnimation.value +
                  _initialHoleRadius
              : (size.height + 100) / 2 * _holeScaleAnimation.value +
                  _initialHoleRadius;
        });
      });
    });
  }

  @override
  void dispose() {
    _holeScaleAnimationController.dispose();
    _appearAnimationController.dispose();
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
        actions: [
          IconButton(
            icon: const Icon(Icons.replay_outlined),
            onPressed: () {
              particles.clear();
              _ticker.stop();
              _appearAnimationController.reset();
              _holeScaleAnimationController.reset();
              _holeRadius = _initialHoleRadius;
              Future.delayed(const Duration(milliseconds: 500), () {
                _appearAnimationController.forward();
              });
            },
          ),
          IconButton(
              icon: const FaIcon(FontAwesomeIcons.github),
              onPressed: () async {
                await GithubLink.openGithubLink(widget.githubUrl);
              })
        ],
      ),
      body: AnimatedBuilder(
        animation: _appearAnimation,
        builder: (context, child) =>
            LayoutBuilder(builder: (context, constraints) {
          final holeCenterPosition = _calcHoleCenterPosition(
              constraints.maxWidth,
              constraints.maxHeight,
              _appearAnimation.value);
          return Stack(
            fit: StackFit.expand,
            children: [
              _buildParticle(holeCenterPosition),
              _buildHole(holeCenterPosition),
              _buildPlayButton(),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildParticle(Offset holeCenterPosition) {
    return CustomPaint(
      painter: ParticlePainter(
        centerPosition: holeCenterPosition,
        particles: particles,
        holeRadius: _holeRadius,
        holeScaleAnimationValue: _holeScaleAnimation.value,
      ),
    );
  }

  Widget _buildHole(Offset holeCenterPosition) {
    return ClipPath(
      clipper:
          HoleClipper(centerPosition: holeCenterPosition, radius: _holeRadius),
      child: Container(
        color: Colors.grey[900],
        width: _holeRadius,
        height: _holeRadius,
      ),
    );
  }

  Widget _buildPlayButton() {
    return Opacity(
      opacity: (1 - _holeScaleAnimation.value * 3).clamp(0, 1),
      child: Align(
          alignment: const Alignment(0, 0.5),
          child: GestureDetector(
            onTap: () {
              if (_ticker.isTicking) {
                _ticker.stop();
                _holeScaleAnimationController.stop();
              } else {
                _ticker.start();
                _holeScaleAnimationController.forward();
              }
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _ticker.isTicking ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
                size: 40,
              ),
            ),
          )),
    );
  }
}

class Particle {
  Particle({required this.holeRadius});
  double holeRadius;

  final double angle = Random().nextDouble() * 2 * pi;

  double x = 0;
  double y = 0;
  int opacity = 255;
  double particleRadius = 3;

  void move() {
    final vx = cos(angle) * 1.5;
    final vy = sin(angle) * 1.5;

    x -= vx;
    y -= vy;
    particleRadius -= 0.02;
    opacity -= 2;
  }
}

class ParticlePainter extends CustomPainter {
  ParticlePainter(
      {required this.particles,
      required this.centerPosition,
      required this.holeRadius,
      required this.holeScaleAnimationValue});
  final List<Particle> particles;
  final Offset centerPosition;
  final double holeRadius;
  final double holeScaleAnimationValue;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));
    Offset calcPosition(Particle particle) {
      return Offset(
          centerPosition.dx + cos(particle.angle) * holeRadius + particle.x,
          centerPosition.dy + sin(particle.angle) * holeRadius + particle.y);
    }

    for (var particle in particles) {
      var paint = Paint()
        ..color =
            Colors.grey[800]!.withOpacity((particle.opacity / 255).clamp(0, 1))
        ..style = PaintingStyle.fill;

      canvas.drawCircle(calcPosition(particle),
          particle.particleRadius * holeScaleAnimationValue * 3, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class HoleClipper extends CustomClipper<Path> {
  final Offset centerPosition;
  final double radius;
  HoleClipper({required this.centerPosition, required this.radius});
  @override
  Path getClip(Size size) {
    return Path()
      ..addOval(
        Rect.fromCircle(
          center: centerPosition,
          radius: (radius - 10).clamp(0, double.infinity),
        ),
      )
      ..addRect(Rect.fromLTWH(0.0, 0.0, size.width, size.height))
      ..fillType = PathFillType.evenOdd;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
