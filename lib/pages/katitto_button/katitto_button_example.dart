import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ui_playground_134/pages/katitto_button/path_utils.dart';
import 'package:ui_playground_134/utils/open_link.dart';

class KatittoButtonExample extends StatefulWidget {
  final String githubUrl;
  const KatittoButtonExample({super.key, required this.githubUrl});

  @override
  State<KatittoButtonExample> createState() => _KatittoButtonExampleState();
}

class _KatittoButtonExampleState extends State<KatittoButtonExample> {
  bool _isOn1 = false;
  bool _isOn2 = false;
  double _inclinationRate = 1.0;
  static const _initialHeight3 = 120.0;
  static const _initialElevation3 = 15.0;
  double _height3 = _initialHeight3;
  double _elevation3 = _initialElevation3;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade200,
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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            KatittoButton(
              onPressed: () {
                setState(() {
                  _isOn1 = !_isOn1;
                });
              },
              width: 200,
              height: 100,
              elevation: 20,
              buttonRadius: 15,
              stageOffset: 10,
              pushedElevationLevel: 0.5,
              inclinationRate: 0.9,
              stageColor: Colors.brown.shade800,
              buttonColor:
                  _isOn1 ? Colors.orange.shade400 : Colors.orange.shade200,
              edgeBorder:
                  Border.all(color: Colors.white.withOpacity(0.5), width: 0.8),
              duration: const Duration(milliseconds: 200),
              child: Center(
                child: Text(
                  _isOn1 ? 'ON' : 'OFF',
                  style: const TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            KatittoButton(
              onPressed: () {
                setState(() {
                  _isOn2 = !_isOn2;
                });
              },
              width: 170,
              height: _height3,
              elevation: _elevation3,
              buttonRadius: 16,
              stageOffset: 8,
              pushedElevationLevel: 0.8,
              inclinationRate: _inclinationRate,
              stageColor: Colors.grey.shade700,
              buttonColor: Colors.green.shade500,
              edgeBorder:
                  Border.all(color: Colors.white.withOpacity(0.5), width: 0.8),
              duration: const Duration(milliseconds: 300),
            ),
            SizedBox(
                width: 300,
                child: Slider(
                  value: _inclinationRate,
                  min: 0.5,
                  max: 1.0,
                  onChanged: (value) {
                    setState(() {
                      _inclinationRate = value;
                      _height3 =
                          -((1 - _inclinationRate) * _initialHeight3 / 2) +
                              _initialHeight3;
                      _elevation3 =
                          ((1 - _inclinationRate) * _initialElevation3 * 2) +
                              _initialElevation3;
                    });
                  },
                )),
          ],
        ),
      ),
    );
  }
}

class KatittoButton extends StatefulWidget {
  final double width;
  final double height;
  final double elevation;
  final double buttonRadius;
  final double stageOffset;
  final Widget? child;
  final Widget? bgWidget;
  final Border? edgeBorder;
  final double inclinationRate;
  final double pushedElevationLevel;
  final Color stageColor;
  final Color? buttonColor;
  final Duration duration;
  final VoidCallback onPressed;

  const KatittoButton({
    super.key,
    this.child,
    this.bgWidget,
    required this.onPressed,
    required this.width,
    required this.height,
    this.stageColor = Colors.grey,
    this.buttonColor,
    this.elevation = 10,
    this.inclinationRate = 0.7,
    this.pushedElevationLevel = 0.7,
    this.edgeBorder,
    this.buttonRadius = 10,
    this.duration = const Duration(milliseconds: 300),
    this.stageOffset = 10.0,
  }) : assert(pushedElevationLevel >= 0.0 && pushedElevationLevel <= 1.0);

  @override
  _KatittoButtonState createState() => _KatittoButtonState();
}

class _KatittoButtonState extends State<KatittoButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double _currentElevation = 0;

  late Path _surfacePath;
  late Path _stagePath;
  late Path _sidePath;

  void _onTap() {
    if (_controller.isAnimating) return;
    Future.delayed(Duration(milliseconds: widget.duration.inMilliseconds ~/ 2),
        () {
      widget.onPressed();
    });

    _controller.forward().then((_) {
      _controller.reverse();
    });
  }

  void _updateElevation() {
    setState(() {
      _currentElevation =
          (1 - widget.pushedElevationLevel * _controller.value) *
              widget.elevation;
      _sidePath = PathUtil.createSidePath(widget.width - widget.stageOffset * 2,
          _currentElevation, widget.buttonRadius, widget.inclinationRate);
    });
  }

  void _createPaths() {
    _surfacePath = PathUtil.createPath(
        widget.width - widget.stageOffset * 2,
        widget.height - widget.elevation - widget.stageOffset,
        widget.buttonRadius,
        widget.inclinationRate);
    _sidePath = PathUtil.createSidePath(widget.width - widget.stageOffset * 2,
        _currentElevation, widget.buttonRadius, widget.inclinationRate);
    _stagePath = PathUtil.createPath(
        widget.width,
        widget.height - widget.elevation,
        widget.buttonRadius + widget.stageOffset,
        widget.inclinationRate);
  }

  @override
  void didUpdateWidget(covariant KatittoButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.inclinationRate != oldWidget.inclinationRate) {
      setState(() {
        _createPaths();
        _updateElevation();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _currentElevation = widget.elevation;
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _controller.addListener(() {
      _updateElevation();
    });

    _createPaths();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: _onTap,
        child: SizedBox(
          width: widget.width,
          height: widget.height,
          child: Stack(
            children: [
              _buildStageShadow(),
              _buildStage(),
              _buildLightShadow(),
              _buildDarkShadow(),
              _buildButton(),
            ],
          ),
        ));
  }

  Widget _clippedSurfaceWidget(
      double width, double height, Widget child, Path path) {
    return SizedBox(
      width: width,
      height: height,
      child: ClipPath(
        clipper: PathClipper(path: path),
        child: child,
      ),
    );
  }

  Widget _buildStage() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: CustomPaint(
        painter: ButtonShapePainter(
          path: _stagePath,
          pathPaint: Paint()
            ..color = widget.stageColor
            ..strokeWidth = 2
            ..style = PaintingStyle.fill,
        ),
        size: PathUtil.getPathSize(_stagePath),
      ),
    );
  }

  Widget _buildStageShadow() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: CustomPaint(
        painter: ShadowPainter(
          path: _stagePath,
        ),
        size: PathUtil.getPathSize(_stagePath),
      ),
    );
  }

  Widget _buildLightShadow() {
    return Positioned(
      bottom: widget.stageOffset,
      left: widget.stageOffset,
      right: widget.stageOffset,
      child: CustomPaint(
        painter: ShadowPainter(
          path: _surfacePath,
          shadowPaint: Paint()
            ..color = Colors.white.withOpacity(0.5)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
        ),
        size: PathUtil.getPathSize(_surfacePath),
      ),
    );
  }

  Widget _buildDarkShadow() {
    return Positioned(
      bottom: widget.stageOffset,
      left: widget.stageOffset,
      right: widget.stageOffset,
      child: CustomPaint(
        painter: ShadowPainter(
          path: _surfacePath,
          shadowPaint: Paint()
            ..color = Colors.black.withOpacity(0.4)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
        ),
        size: PathUtil.getPathSize(_surfacePath),
      ),
    );
  }

  Widget _buildSideButton() {
    final Size size = PathUtil.getPathSize(_sidePath);
    return Positioned(
      bottom: widget.stageOffset,
      left: widget.stageOffset,
      right: widget.stageOffset,
      child: _clippedSurfaceWidget(
        size.width,
        size.height,
        Stack(
          fit: StackFit.expand,
          children: [
            widget.bgWidget ??
                ColoredBox(color: widget.buttonColor ?? Colors.red),
            ColoredBox(
              color: Colors.black.withOpacity(0.2),
            )
          ],
        ),
        _sidePath,
      ),
    );
  }

  Widget _buildSurfaceButton() {
    final Size size = PathUtil.getPathSize(_surfacePath);
    return Positioned(
      bottom: widget.stageOffset + _currentElevation,
      left: widget.stageOffset,
      right: widget.stageOffset,
      child: Stack(
        children: [
          _clippedSurfaceWidget(
            size.width,
            size.height,
            widget.bgWidget ??
                ColoredBox(color: widget.buttonColor ?? Colors.red),
            _surfacePath,
          ),
          SizedBox(
            width: size.width,
            height: size.height,
            child: widget.child,
          )
        ],
      ),
    );
  }

  Widget _buildButton() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          children: [
            _buildSideButton(),
            _buildSurfaceButton(),
          ],
        );
      },
    );
  }
}

class PathClipper extends CustomClipper<Path> {
  final Path path;
  PathClipper({required this.path});
  @override
  Path getClip(Size size) => path;

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class ButtonShapePainter extends CustomPainter {
  final Path path;
  final Paint? pathPaint;
  ButtonShapePainter({required this.path, this.pathPaint});
  @override
  void paint(Canvas canvas, Size size) {
    final basePaint = Paint()
      ..color = Colors.red
      ..strokeWidth = 2
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;
    canvas.drawPath(path, pathPaint ?? basePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class ShadowPainter extends CustomPainter {
  final Path path;
  final Paint? shadowPaint;
  ShadowPainter({
    required this.path,
    this.shadowPaint,
  });
  @override
  void paint(Canvas canvas, Size size) {
    final baseShadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.5)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
    canvas.drawPath(
        path.shift(const Offset(0, 1)), shadowPaint ?? baseShadowPaint);
    canvas.drawPath(path, shadowPaint ?? baseShadowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
