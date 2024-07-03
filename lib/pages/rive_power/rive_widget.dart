import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class RiveWidget extends StatefulWidget {
  final double shineValue;
  const RiveWidget({super.key, required this.shineValue});

  @override
  State<RiveWidget> createState() => _RiveWidgetState();
}

class _RiveWidgetState extends State<RiveWidget> {
  SMIInput<double>? _shine;
  void _onRiveInit(Artboard artboard) {
    final controller = StateMachineController.fromArtboard(artboard, 'state');
    artboard.addController(controller!);
    _shine = controller.findInput<double>('shine') as SMINumber;
    _shine?.value = 0.0;
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
    _shine?.value = widget.shineValue;
  }

  @override
  void didUpdateWidget(RiveWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.shineValue != oldWidget.shineValue) {
      _shine?.value = widget.shineValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 400,
        maxHeight: 400,
        minWidth: 0,
        minHeight: 0,
      ),
      child: SizedBox(
        width: size.width * 0.8,
        height: size.width * 0.8,
        child: Stack(
          fit: StackFit.expand,
          children: [
            RiveAnimation.asset(
              'assets/rive/power.riv',
              fit: BoxFit.contain,
              onInit: (artboard) {
                _onRiveInit(artboard);
              },
            ),
          ],
        ),
      ),
    );
  }
}
