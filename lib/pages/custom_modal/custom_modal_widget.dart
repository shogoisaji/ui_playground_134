import 'package:flutter/material.dart';
import 'package:ui_playground_134/pages/custom_modal/custom_modal_example.dart';

class CustomModal extends PopupRoute {
  final int selectedIndex;
  final List<Image> imageList;
  final Function(int) onSetIndex;
  CustomModal(
      {required this.selectedIndex,
      required this.imageList,
      required this.onSetIndex});

  @override
  AnimationController createAnimationController() {
    return AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: navigator!.overlay!,
    );
  }

  @override
  Color? get barrierColor => Colors.black54;

  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => null;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: Tween<double>(begin: 0.5, end: 1.0).animate(
          CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          ),
        ),
        child: CustomModalWidget(
          imageList: imageList,
          selectedIndex: selectedIndex,
          onSetIndex: onSetIndex,
        ),
      ),
    );
  }

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);
}

class CustomModalWidget extends StatefulWidget {
  final List<Image> imageList;
  final int selectedIndex;
  final Function(int) onSetIndex;
  const CustomModalWidget(
      {super.key,
      required this.imageList,
      required this.selectedIndex,
      required this.onSetIndex});

  @override
  State<CustomModalWidget> createState() => _CustomModalWidget();
}

class _CustomModalWidget extends State<CustomModalWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  late TweenSequence<double> _tween1;
  late TweenSequence<double> _tween2;

  final List<int> _showIndexList = [];

  void _setIndex(int index) {
    setState(() {
      _showIndexList.clear();
      _showIndexList.addAll(
        List.generate(widget.imageList.length, (i) => i)
          ..removeWhere((e) => e == widget.selectedIndex),
      );
    });
  }

  @override
  void initState() {
    super.initState();

    _setIndex(widget.selectedIndex);

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    // ここでtween1とtween2を初期化
    _tween1 = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: -1.0, end: 0.0),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: 0.0),
        weight: 1,
      ),
    ]);

    _tween2 = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: -1.0, end: -1.0),
        weight: 0.7,
      ),
      TweenSequenceItem(
        tween: Tween(begin: -1.0, end: 0.0),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: 0.0),
        weight: 0.2,
      ),
    ]);

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final h = MediaQuery.sizeOf(context).height;

    return Align(
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Material(
            color: Colors.transparent,
            child: SafeArea(
              child: SizedBox(
                width: (w * 0.8).clamp(0, 500),
                height: h,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _buildContentItem(_tween2, 1),
                    _buildContentItem(_tween1, 0),
                    _buildCloseButton(context)
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildContentItem(TweenSequence<double> tween, int index) {
    return Transform.translate(
      offset: Offset(0.0,
          tween.animate(_animation).value * MediaQuery.of(context).size.height),
      child: GestureDetector(
        onTap: () => widget.onSetIndex(_showIndexList[index]),
        child: ContentWidget(
          image: widget.imageList[_showIndexList[index]],
          isLoading: false,
          color: contentColors[_showIndexList[index] % contentColors.length],
          index: _showIndexList[index],
        ),
      ),
    );
  }

  Widget _buildCloseButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: ElevatedButton(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text('Close'),
      ),
    );
  }
}

class ContentWidget extends StatelessWidget {
  final bool isLoading;
  final Image? image;
  final Color color;
  final int index;
  const ContentWidget(
      {super.key,
      this.image,
      required this.isLoading,
      required this.color,
      required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250.0,
      height: 150,
      margin: const EdgeInsets.only(top: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color, width: 8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            isLoading
                ? ColoredBox(
                    color: Colors.grey.withOpacity(0.3),
                  )
                : image ?? const SizedBox.shrink(),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      blurRadius: 8,
                      offset: const Offset(-1, -1),
                    ),
                  ],
                ),
                child: Text(
                  'content ${index + 1}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
