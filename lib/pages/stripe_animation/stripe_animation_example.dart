import 'package:flutter/material.dart';
import 'package:ui_playground_134/pages/stripe_animation/stripe_animation_widget.dart';

class StripeAnimationExample extends StatefulWidget {
  const StripeAnimationExample({super.key});

  @override
  State<StripeAnimationExample> createState() => _StripeAnimationExampleState();
}

class _StripeAnimationExampleState extends State<StripeAnimationExample>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();

  int _tabNumber = 0;

  void _handleTapTag(int number) {
    setState(() {
      _tabNumber = number;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _TabSelector(
                    text: 'Drink',
                    isEnable: _tabNumber == 0,
                    onTap: () {
                      _handleTapTag(0);
                      _pageController.animateToPage(0,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut);
                    }),
                _TabSelector(
                    text: 'Food',
                    isEnable: _tabNumber == 1,
                    onTap: () {
                      _handleTapTag(1);
                      _pageController.animateToPage(1,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut);
                    }),
                _TabSelector(
                    text: 'Coffee',
                    isEnable: _tabNumber == 2,
                    onTap: () {
                      _handleTapTag(2);
                      _pageController.animateToPage(2,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut);
                    }),
                _TabSelector(
                    text: 'Milk',
                    isEnable: _tabNumber == 3,
                    onTap: () {
                      _handleTapTag(3);
                      _pageController.animateToPage(3,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut);
                    }),
              ],
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              color: Colors.blue,
              child: PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: _pageController,
                children: [
                  _pageContent('Drink', Colors.blue.shade100),
                  _pageContent('Food', Colors.green.shade200),
                  _pageContent('Cafe', Colors.yellow.shade300),
                  _pageContent('Milk', Colors.pink.shade400),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _pageContent(String text, Color color) {
    return Container(
      color: color,
      child: Align(
        alignment: const Alignment(0.0, -0.6),
        child: Text(text,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            )),
      ),
    );
  }
}

class _TabSelector extends StatefulWidget {
  final String text;
  final bool isEnable;
  final void Function() onTap;
  const _TabSelector({
    required this.text,
    required this.isEnable,
    required this.onTap,
  });

  @override
  State<_TabSelector> createState() => _TabSelectorState();
}

class _TabSelectorState extends State<_TabSelector>
    with SingleTickerProviderStateMixin {
  static const animationDuration = Duration(milliseconds: 700);
  static const _stripeWidth = 5.0;
  static const _moveRange = 50.0;
  static const _enableColor = Colors.deepOrangeAccent;
  static const _disableColor = Colors.blue;
  static const _fontSize = 24.0;

  late AnimationController _animationController;

  @override
  void didUpdateWidget(covariant _TabSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isEnable != widget.isEnable) {
      if (widget.isEnable) {
        _animationController.forward(from: 0.8);
        _animationController.reverse();
      } else {
        _animationController.reset();
        _animationController.forward();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(duration: animationDuration, vsync: this);
    _animationController.addListener(() {
      if (_animationController.status == AnimationStatus.completed) {
        _animationController.reset();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: StripeAnimationWidget(
        animationController: _animationController,
        stripeWidth: _stripeWidth,
        moveRange: _moveRange,
        child: Text(widget.text,
            style: TextStyle(
              fontSize: _fontSize,
              fontWeight: FontWeight.bold,
              color: widget.isEnable ? _enableColor : _disableColor,
            )),
      ),
    );
  }
}
