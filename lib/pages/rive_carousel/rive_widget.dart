import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class RiveWidget extends StatefulWidget {
  final double walkValue;
  final Image image;
  const RiveWidget({super.key, required this.walkValue, required this.image});

  @override
  State<RiveWidget> createState() => _RiveWidgetState();
}

class _RiveWidgetState extends State<RiveWidget> {
  SMIInput<double>? _color;
  SMIInput<double>? _walk;

  void _onRiveInit(Artboard artboard) {
    final controller = StateMachineController.fromArtboard(artboard, 'state');
    artboard.addController(controller!);
    _color = controller.findInput<double>('color') as SMINumber;
    _walk = controller.findInput<double>('walk') as SMINumber;
    _color!.value = Random().nextInt(5).toDouble();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _walk?.value = widget.walkValue;
  }

  @override
  void didUpdateWidget(RiveWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.walkValue != oldWidget.walkValue) {
      _walk?.value = widget.walkValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 300,
      child: Stack(
        fit: StackFit.expand,
        children: [
          RiveAnimation.asset(
            'assets/rive/character.riv',
            fit: BoxFit.contain,
            onInit: (artboard) {
              _onRiveInit(artboard);
            },
          ),
          Center(
            child: SizedBox(
              width: 300 * 4 / 5,
              height: 300 * 4.5 / 8,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: widget.image,
              ),
            ),
          )
        ],
      ),
    );
  }
}
