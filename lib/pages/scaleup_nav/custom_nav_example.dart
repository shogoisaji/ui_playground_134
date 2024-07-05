import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ui_playground_134/pages/scaleup_nav/second_page.dart';
import 'package:ui_playground_134/utils/open_link.dart';

class ScaleupNavExample extends StatefulWidget {
  final String githubUrl;
  const ScaleupNavExample({super.key, required this.githubUrl});

  @override
  State<ScaleupNavExample> createState() => _ScaleupNavExampleState();
}

class _ScaleupNavExampleState extends State<ScaleupNavExample> {
  Route _scaleUpRoute(
      Offset beginPosition, Size beginSize, Widget prevWidget, String props) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 300),
      reverseTransitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, animation, secondaryAnimation) =>
          SecondPage(text: props),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final size = MediaQuery.sizeOf(context);
        final scaleX =
            Tween<double>(begin: beginSize.width / size.width, end: 1.0);
        final scaleY =
            Tween<double>(begin: beginSize.height / size.height, end: 1.0);
        final prevWidgetScaleX =
            Tween<double>(begin: 1.0, end: size.width / beginSize.width);
        final prevWidgetScaleY =
            Tween<double>(begin: 1.0, end: size.height / beginSize.height);
        final topPosition = Tween<double>(begin: beginPosition.dy, end: 0);
        final leftPosition = Tween<double>(begin: beginPosition.dx, end: 0);
        return Stack(
          children: [
            _buildPrevWidgetAnimation(animation, topPosition, leftPosition,
                prevWidgetScaleX, prevWidgetScaleY, beginSize, prevWidget),
            _buildAnimatedChild(
                animation, topPosition, leftPosition, scaleX, scaleY, child),
          ],
        );
      },
    );
  }

  Widget _buildAnimatedChild(
      Animation<double> animation,
      Tween<double> topPosition,
      Tween<double> leftPosition,
      Tween<double> scaleX,
      Tween<double> scaleY,
      Widget child) {
    return Positioned(
      top: topPosition.animate(animation).value,
      left: leftPosition.animate(animation).value,
      child: Transform.scale(
        alignment: Alignment.topLeft,
        scaleX: scaleX.animate(animation).value,
        scaleY: scaleY.animate(animation).value,
        child: Opacity(
          opacity: animation.value,
          child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: child),
        ),
      ),
    );
  }

  Widget _buildPrevWidgetAnimation(
      Animation<double> animation,
      Tween<double> topPosition,
      Tween<double> leftPosition,
      Tween<double> scaleX,
      Tween<double> scaleY,
      Size beginSize,
      Widget prevWidget) {
    return Positioned(
      top: topPosition.animate(animation).value,
      left: leftPosition.animate(animation).value,
      child: Transform.scale(
        alignment: Alignment.topLeft,
        scaleX: scaleX.animate(animation).value,
        scaleY: scaleY.animate(animation).value,
        child: IgnorePointer(
          child: Opacity(
            opacity: (1 - animation.value * 1.0).clamp(0.0, 1.0),
            child: SizedBox(
              width: beginSize.width,
              height: beginSize.height,
              child: Material(
                color: Colors.transparent,
                child: prevWidget,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      _tapNavContent(
                          context,
                          160,
                          const Center(
                              child: Text('First Page',
                                  style: TextStyle(color: Colors.white))),
                          color: Colors.orange,
                          'First Page'),
                      _tapNavContent(
                          context,
                          200,
                          Center(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Second Page',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold)),
                              Container(
                                width: 100,
                                height: 100,
                                color: Colors.pink,
                              ),
                            ],
                          )),
                          'Second Page',
                          color: Colors.green),
                      _tapNavContent(
                          context,
                          230,
                          Center(
                              child: Image.network(
                            'https://picsum.photos/200/300?random=1',
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          )),
                          'Image'),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      _tapNavContent(
                          context,
                          210,
                          const Center(
                              child: Text('third Page',
                                  style: TextStyle(
                                      color: Colors.blueGrey,
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold))),
                          'third Page'),
                      _tapNavContent(
                          context,
                          100,
                          const Center(child: Text('fourth Page')),
                          'fourth Page',
                          color: Colors.brown),
                      _tapNavContent(
                        context,
                        280,
                        Center(
                            child: Image.network(
                          'https://picsum.photos/200/300?random=2',
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        )),
                        'Image',
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 100),
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                margin: const EdgeInsets.only(top: 10, left: 10),
                height: 400,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                width: MediaQuery.of(context).size.width * 0.8,
                child: ListView.builder(
                  itemCount: 20,
                  itemBuilder: (context, index) {
                    return _tapNavContent(
                        context,
                        100,
                        Center(
                            child: Text('Item $index',
                                style: const TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold))),
                        'Item $index',
                        color: HSVColor.fromAHSV(1.0,
                                (math.Random().nextDouble() * 360), 1.0, 1.0)
                            .toColor());
                  },
                ),
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _tapNavContent(
      BuildContext context, double h, Widget child, String props,
      {Color color = Colors.white}) {
    final content = Container(
        height: h,
        margin: const EdgeInsets.only(top: 10, bottom: 0, left: 10, right: 10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: child,
        ));
    return Builder(
      builder: (BuildContext context) {
        return GestureDetector(
            onTap: () {
              final RenderBox box = context.findRenderObject() as RenderBox;
              final size = box.size;
              final position = box.localToGlobal(Offset.zero);
              Navigator.push(
                context,
                _scaleUpRoute(
                  position,
                  size,
                  content,
                  props,
                ),
              );
            },
            child: content);
      },
    );
  }
}
