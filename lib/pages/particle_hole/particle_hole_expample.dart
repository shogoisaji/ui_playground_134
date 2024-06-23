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
  static const double _initialRadius = 20;

  late AnimationController _startAnimationController;
  late Animation<double> _startAnimation;
  late AnimationController _circleMoveAnimationController;
  late Animation<double> _circleMoveAnimation;
  final List<Particle> particles = [];
  late Ticker _ticker;
  double _opacity = 1.0;
  double _circleRadius = _initialRadius;
  double _particleRadius = 0;
  Offset position = const Offset(0, 0);
  Offset _clipCenterPosition = const Offset(0, 0);
  @override
  void initState() {
    super.initState();

    _startAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 3000));
    _startAnimation = CurvedAnimation(
        parent: _startAnimationController, curve: Curves.easeOutQuart);
    Future.delayed(const Duration(milliseconds: 500), () {
      _startAnimationController.forward();
    });

    _circleMoveAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 3000));
    _circleMoveAnimation = CurvedAnimation(
        parent: _circleMoveAnimationController, curve: Curves.easeInOut);

    _ticker = createTicker((elapsed) {
      for (var i = 0; i < 30; i++) {
        /// 1270個のパーティクルを生成 127個/i
        particles.add(Particle(particleRadius: _particleRadius));
      }
      for (var particle in particles) {
        particle.move();
      }

      /// opacityが0になったパーティクルを削除
      particles.removeWhere((particle) => particle.opacity <= 0);
      setState(() {});
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final size = MediaQuery.sizeOf(context);
      // position = Offset(size.width / 2, size.height / 2);
      _circleMoveAnimation.addListener(() {
        setState(() {
          _particleRadius = _circleMoveAnimation.value * 6 + 2.5;
          _opacity = (_circleMoveAnimation.value + 0.5).clamp(0, 1);
          _circleRadius = size.width > size.height
              ? (size.width + 100) / 2 * _circleMoveAnimation.value +
                  _initialRadius
              : (size.height + 100) / 2 * _circleMoveAnimation.value +
                  _initialRadius;
        });
      });
      _startAnimation.addListener(() {
        setState(() {
          _clipCenterPosition = Offset(MediaQuery.sizeOf(context).width / 2,
              (MediaQuery.sizeOf(context).height / 2 * _startAnimation.value));
        });
      });
    });
  }

  @override
  void dispose() {
    _circleMoveAnimationController.dispose();
    _startAnimationController.dispose();
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
            icon: const Icon(Icons.replay_outlined, color: Colors.white),
            onPressed: () {
              setState(() {
                particles.clear();
                _ticker.stop();
                _startAnimationController.reset();
                _circleMoveAnimationController.reset();
                _circleRadius = _initialRadius;
                Future.delayed(const Duration(milliseconds: 500), () {
                  _startAnimationController.forward();
                });
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
      body: Stack(
        fit: StackFit.expand,
        children: [
          Opacity(
            opacity: _opacity,
            child: CustomPaint(
              painter: ParticlePainter(
                centerPosition: _clipCenterPosition,
                particles: particles,
                circleRadius: _circleRadius,
              ),
            ),
          ),
          ClipPath(
            clipper: MyClipper(
                centerPosition: _clipCenterPosition, radius: _circleRadius),
            child: Container(
              color: Colors.grey[900],
              width: _circleRadius,
              height: _circleRadius,
            ),
          ),
          Opacity(
            opacity: (1 - _circleMoveAnimation.value * 3).clamp(0, 1),
            child: Align(
                alignment: const Alignment(0, 0.5),
                child: GestureDetector(
                  onTap: () {
                    if (_ticker.isTicking) {
                      _ticker.stop();
                      _circleMoveAnimationController.stop();
                    } else {
                      _ticker.start();
                      _circleMoveAnimationController.forward();
                    }
                  },
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 2),
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(4),
                    child: const Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                )),
          ),
        ],
      ),
    );
  }
}

class Particle {
  double angle = Random().nextDouble() * 2 * pi;
  double x = 0;
  double y = 0;
  double particleRadius;
  int opacity = 255;

  Particle({required this.particleRadius});

  void move() {
    final vx = cos(angle) * particleRadius / 3;
    final vy = sin(angle) * particleRadius / 3;
    x -= vx;
    y -= vy;
    particleRadius -= 0.05;
    opacity -= 2;
  }
}

class ParticlePainter extends CustomPainter {
  final Offset centerPosition;
  final List<Particle> particles;
  final double circleRadius;
  ParticlePainter(
      {required this.particles,
      required this.centerPosition,
      required this.circleRadius});

  @override
  void paint(Canvas canvas, Size size) {
    Offset calculatePosition(Particle particle) {
      return Offset(
          centerPosition.dx + cos(particle.angle) * circleRadius + particle.x,
          centerPosition.dy + sin(particle.angle) * circleRadius + particle.y);
    }

    for (var particle in particles) {
      var paint = Paint()
        ..color =
            Colors.grey[800]!.withOpacity((particle.opacity / 255).clamp(0, 1))
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
          calculatePosition(particle), particle.particleRadius, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class MyClipper extends CustomClipper<Path> {
  final Offset centerPosition;
  final double radius;
  MyClipper({required this.centerPosition, required this.radius});
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
