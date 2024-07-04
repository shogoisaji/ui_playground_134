import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ui_playground_134/pages/spin_overlay/tapped_image.dart';

class SelectedSpinWidget extends StatefulWidget {
  const SelectedSpinWidget({
    super.key,
    required this.index,
    required this.imageLink,
  });

  final int index;
  final String imageLink;

  @override
  State<SelectedSpinWidget> createState() => _SelectedSpinWidgetState();
}

class _SelectedSpinWidgetState extends State<SelectedSpinWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final imageSize = const Size(200.0, 130.0);

  bool _isSelected = false;
  double _scale = 1.0;

  TappedImage? _tappedImage;

  OverlayEntry? _overlayEntry;

  final GlobalKey _tapedImageKey = GlobalKey();

  void _getTapedImageData() {
    final RenderBox? renderBox =
        _tapedImageKey.currentContext?.findRenderObject() as RenderBox?;
    final Offset? offset = renderBox?.localToGlobal(Offset.zero);
    final Size? size = renderBox?.size;
    if (offset == null || size == null) {
      throw Exception("offset or size is null");
    }
    _tappedImage = TappedImage(
      offset: offset,
      size: size,
      imageLink: widget.imageLink,
    );
  }

  void _handleTapSelectedImage() {
    final nextScale = switch (_scale) {
      1.0 => 2.0,
      2.0 => 3.0,
      3.0 => 1.0,
      _ => 1.0,
    };
    setState(() {
      _scale = nextScale;
    });
    _animationController.reset();
    _animationController.forward(from: 0.15);

    /// overlayの再描画
    _overlayEntry?.markNeedsBuild();
  }

  void _handlePanUpdate(details) {
    if (_tappedImage == null) return;
    final adjustedDelta =
        Offset(-details.delta.dx * 1.5, details.delta.dy * 1.5);
    final updatedTappedImage =
        _tappedImage!.copyWith(offset: _tappedImage!.offset + adjustedDelta);
    setState(() {
      _tappedImage = updatedTappedImage;
    });

    /// overlayの再描画
    _overlayEntry?.markNeedsBuild();
  }

  void _handleTap(BuildContext context) {
    setState(() {
      _isSelected = true;
    });
    _getTapedImageData();
    if (_tappedImage == null) return;
    _showOverlay(context);
    _animationController.reset();
    _animationController.forward();
  }

  void _showOverlay(BuildContext context) {
    if (_tappedImage == null) return;
    _overlayEntry = OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: _removeOverlay,
        child: Container(
          color: Colors.black.withOpacity(0.5),
          child: Stack(
            children: [
              Positioned(
                top: _tappedImage!.offset.dy,
                left: _tappedImage!.offset.dx,
                child: SpinAnimationWidget(
                  width: _tappedImage!.size.width * _scale,
                  animationController: _animationController,
                  child: GestureDetector(
                      onTap: () {
                        _handleTapSelectedImage();
                      },
                      onPanUpdate: (details) {
                        _handlePanUpdate(details);
                      },
                      child: CachedNetworkImage(
                        key: _tapedImageKey,
                        imageUrl: widget.imageLink,
                        width: _tappedImage!.size.width * _scale,
                        height: _tappedImage!.size.height * _scale,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          width: _tappedImage!.size.width * _scale,
                          height: _tappedImage!.size.height * _scale,
                          color: Colors.grey[400],
                        ),
                        errorWidget: (context, url, error) => Container(
                          width: _tappedImage!.size.width * _scale,
                          height: _tappedImage!.size.height * _scale,
                          color: Colors.grey[400],
                          child: const Icon(Icons.error),
                        ),
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (context.mounted) {
      setState(() {
        _isSelected = false;
        _scale = 1.0;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _removeOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _handleTap(context);
      },
      child: Card(
        color: Colors.white,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Container(
          height: imageSize.height,
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Image ${widget.index}"),
              _isSelected
                  ? const SizedBox.shrink()
                  : CachedNetworkImage(
                      key: _tapedImageKey,
                      imageUrl: widget.imageLink,
                      width: imageSize.width,
                      height: imageSize.height,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        width: imageSize.width,
                        height: imageSize.height,
                        color: Colors.grey[400],
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: imageSize.width,
                        height: imageSize.height,
                        color: Colors.grey[400],
                        child: const Icon(Icons.error),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class SpinAnimationWidget extends StatefulWidget {
  final Widget child;
  final AnimationController animationController;
  final double width;
  const SpinAnimationWidget(
      {super.key,
      required this.child,
      required this.animationController,
      required this.width});

  @override
  State<SpinAnimationWidget> createState() => _SpinAnimationWidgetState();
}

class _SpinAnimationWidgetState extends State<SpinAnimationWidget> {
  late Animation<double> _animation;
  @override
  void initState() {
    super.initState();
    _animation = CurvedAnimation(
        parent: widget.animationController, curve: Curves.easeOutBack);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) => Transform(
          transform: Matrix4.identity()
            ..translate(widget.width / 2, 0, 0)
            ..rotateX(0.2)
            ..rotateY(3.5 * _animation.value)
            ..translate(-widget.width / 2, -10 * _animation.value, 0)
            ..scale(
                1.0 + 0.5 * _animation.value, 1.0 + 0.5 * _animation.value, 1),
          child: widget.child),
    );
  }
}
