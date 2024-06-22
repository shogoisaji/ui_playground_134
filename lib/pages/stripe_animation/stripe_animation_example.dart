import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ui_playground_134/pages/stripe_animation/stripe_animation_widget.dart';
import 'package:ui_playground_134/utils/github_link.dart';

class StripeAnimationExample extends StatefulWidget {
  final String githubUrl;
  const StripeAnimationExample({super.key, required this.githubUrl});

  @override
  State<StripeAnimationExample> createState() => _StripeAnimationExampleState();
}

class _StripeAnimationExampleState extends State<StripeAnimationExample>
    with SingleTickerProviderStateMixin {
  final List<Map<String, dynamic>> tagList = [
    {'label': 'Drink', 'color': Colors.blue.shade100},
    {'label': 'Food', 'color': Colors.green.shade200},
    {'label': 'Cafe', 'color': Colors.yellow.shade300},
    {'label': 'Milk', 'color': Colors.pink.shade400},
  ];

  final PageController _pageController = PageController();

  int _tabNumber = 0;

  void _handleTapTag(int number) {
    setState(() {
      _tabNumber = number;
    });
    _pageController.animateToPage(number,
        duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
        actions: [
          IconButton(
              icon: const FaIcon(FontAwesomeIcons.github),
              onPressed: () async {
                await GithubLink.openGithubLink(widget.githubUrl);
              })
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                for (int i = 0; i < tagList.length; i++)
                  _TabSelector(
                    text: tagList[i]['label'],
                    isEnable: _tabNumber == i,
                    onTap: () {
                      _handleTapTag(i);
                    },
                  ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.blue,
              width: double.infinity,
              child: PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: _pageController,
                children: [
                  for (int i = 0; i < tagList.length; i++)
                    _pageContent(tagList[i]['label'], tagList[i]['color']),
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
        maxStripeOffset: _moveRange,
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
