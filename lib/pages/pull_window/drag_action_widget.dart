import 'package:flutter/material.dart';
import 'package:ui_playground_134/pages/pull_window/card_model.dart';

class DragActionWidget extends StatefulWidget {
  final CardModel cardModel;
  final Offset targetPosition;
  final double intoAreaOffset;
  final VoidCallback onAccepted;
  final VoidCallback onSelfDetach;
  final bool isAccepted;
  const DragActionWidget(
      {super.key,
      required this.cardModel,
      required this.targetPosition,
      required this.intoAreaOffset,
      required this.isAccepted,
      required this.onSelfDetach,
      required this.onAccepted});

  @override
  State<DragActionWidget> createState() => _DragActionWidgetState();
}

class _DragActionWidgetState extends State<DragActionWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _positionAnimation;

  late CardModel _cardModel;
  late double _currentWidth;
  late double _currentHeight;

  OverlayEntry? _overlay;
  bool _isIntoArea = false;
  bool _isDragging = false;
  bool _isSelfDetached = false;
  double _progress = 0;

  void _removeOverlay() {
    _overlay?.remove();
    _overlay = null;
  }

  void _updateParameter(Offset position) {
    /// 初期位置からの距離(initStateで取得すると数値がズレる)
    final initialDistance =
        (widget.targetPosition - widget.cardModel.initialPosition).distance;

    /// 現在位置からの距離
    final distance = (position - widget.targetPosition).distance;

    /// 距離による進捗率 近くが"1" 遠いほど"0"
    _progress = (1 - distance / initialDistance).clamp(0, 1);

    /// 角度
    final angle = _cardModel.initialAngle * (1 - _progress);

    /// positionがtargetPositionの周囲intoAreaOffset内かどうか
    _isIntoArea = distance < widget.intoAreaOffset;

    /// 現在のcardのサイズを更新
    _currentWidth = widget.cardModel.beforeWidth +
        (widget.cardModel.afterWidth - widget.cardModel.beforeWidth) *
            _progress;
    _currentHeight = widget.cardModel.beforeHeight +
        (widget.cardModel.afterHeight - widget.cardModel.beforeHeight) *
            _progress;

    /// 値の更新
    _cardModel = _cardModel.copyWith(
      position: position,
      distance: distance,
      currentAngle: angle,
    );
  }

  void _setAnimation() {
    final positionEnd = switch (_isIntoArea) {
      true => widget.targetPosition,
      false => _cardModel.initialPosition,
    };

    _positionAnimation =
        Tween<Offset>(begin: _cardModel.position, end: positionEnd).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutBack,
      ),
    );
  }

  void _backInitialPosition() {
    _cardModel = _cardModel.copyWith(
      position: _cardModel.initialPosition,
    );
    _positionAnimation = Tween<Offset>(
            begin: widget.targetPosition, end: _cardModel.initialPosition)
        .animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutBack,
      ),
    );
    _animationController.reset();
    _animationController.forward();
  }

  void _addOverlay() {
    final double topPadding = MediaQuery.of(context).padding.top;
    final double appBarHeight = AppBar().preferredSize.height;

    OverlayEntry createOverlayEntry() {
      return OverlayEntry(
        builder: (context) {
          return AnimatedBuilder(
              animation: _positionAnimation,
              builder: (context, child) {
                return Positioned(
                  top: _cardModel.position!.dy -
                      _currentHeight / 2 +
                      (topPadding + appBarHeight),
                  left: _cardModel.position!.dx - _currentWidth / 2,
                  child: Transform.rotate(
                    angle: _cardModel.currentAngle ?? 0.0,
                    child: Material(
                      color: Colors.transparent,
                      child: _cardWidget(
                        _cardModel,
                        _progress,
                        _currentWidth,
                        _currentHeight,
                      ),
                    ),
                  ),
                );
              });
        },
      );
    }

    _overlay = createOverlayEntry();
    Overlay.of(context).insert(_overlay!);
  }

  void _handlePanStart() {
    _isSelfDetached = false;
    _addOverlay();
    setState(() {
      _isDragging = true;
    });
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    final position = Offset(
      _cardModel.position!.dx + details.delta.dx,
      _cardModel.position!.dy + details.delta.dy,
    );
    _updateParameter(position);
    _overlay?.markNeedsBuild();
  }

  void _handlePanEnd(_) async {
    _setAnimation();
    _animationController.reset();
    _animationController.forward().then((_) {
      _removeOverlay();
      setState(() {
        _isDragging = false;
      });
    });

    /// 範囲内でドラッグを修了した場合
    if (_isIntoArea) {
      widget.onAccepted();
      return;
    }

    /// 範囲外でドラッグを修了した場合 & 自分がacceptしている場合
    if (widget.isAccepted && !_isIntoArea) {
      _isSelfDetached = true;
      widget.onSelfDetach();
    } else {
      _isSelfDetached = false;
    }
  }

  @override
  void initState() {
    super.initState();
    _currentWidth = widget.cardModel.beforeWidth;
    _currentHeight = widget.cardModel.beforeHeight;
    _cardModel = widget.cardModel.copyWith(
      currentAngle: widget.cardModel.initialAngle,
      position: widget.cardModel.initialPosition,
    );
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _positionAnimation = Tween<Offset>(
      begin: _cardModel.position,
      end: widget.targetPosition,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutBack,
      ),
    );
    _animationController.addListener(() {
      _updateParameter(_positionAnimation.value);
      _overlay?.markNeedsBuild();
      setState(() {});
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _removeOverlay();
    super.dispose();
  }

  @override
  void didUpdateWidget(DragActionWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isAccepted != oldWidget.isAccepted && !widget.isAccepted) {
      /// 外部から除外された場合
      if (!_isSelfDetached) {
        _backInitialPosition();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: _cardModel.position!.dy - _currentHeight / 2,
          left: _cardModel.position!.dx - _currentWidth / 2,
          child: GestureDetector(
            onPanStart: (details) {
              _handlePanStart();
            },
            onPanUpdate: (details) {
              _handlePanUpdate(details);
            },
            onPanEnd: (details) {
              _handlePanEnd(details);
            },
            child: Transform.rotate(
              angle: _cardModel.currentAngle ?? 0.0,
              child: Opacity(
                  opacity: _isDragging ? 0.0 : 1.0,
                  child: _cardWidget(
                      _cardModel, _progress, _currentWidth, _currentHeight)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _cardWidget(
      CardModel cardModel, double progress, double width, double height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.red.shade400,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          cardModel.beforeChild,
          Opacity(
            opacity: progress.clamp(0, 1),
            child: cardModel.afterChild,
          ),
        ],
      ),
    );
  }
}
