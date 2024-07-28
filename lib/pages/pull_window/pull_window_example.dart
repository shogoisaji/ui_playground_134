import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ui_playground_134/pages/pull_window/drag_action_widget.dart';
import 'package:ui_playground_134/utils/open_link.dart';

class PullWindowExample extends StatefulWidget {
  final String githubUrl;
  const PullWindowExample({super.key, required this.githubUrl});

  @override
  State<PullWindowExample> createState() => _PullWindowExampleState();
}

class _PullWindowExampleState extends State<PullWindowExample> {
  Offset targetPosition = Offset.zero;
  // static const Offset targetPosition = Offset(220, 200);
  static const Size cardSize = Size(100, 150);
  static const acceptArea = 100.0;

  int? _currentIndex;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        targetPosition = Offset(MediaQuery.of(context).size.width / 2,
            (MediaQuery.of(context).size.height - kToolbarHeight) / 2);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
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
      body: Stack(
        fit: StackFit.expand,
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Text(
              '$_currentIndex',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _currentIndex = null;
                });
              },
              child: const Text('Back'),
            ),
          ),
          Positioned(
            top: targetPosition.dy - cardSize.height / 2,
            left: targetPosition.dx - cardSize.width / 2,
            child: IgnorePointer(
              child: Container(
                width: cardSize.width,
                height: cardSize.height,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.blue,
                    width: 5,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          DragActionWidget(
            initialWidget: const ColoredBox(
              color: Colors.brown,
              child: Center(
                child: Text(
                  '0',
                  style: TextStyle(color: Colors.white, fontSize: 32),
                ),
              ),
            ),
            appliedWidget: Container(
                width: cardSize.width,
                height: cardSize.height,
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text(
                    '"0"',
                    style: TextStyle(color: Colors.white, fontSize: 32),
                  ),
                )),
            width: cardSize.width,
            height: cardSize.height,
            initialPosition: const Offset(20, 90),
            targetPosition: targetPosition,
            intoArea: acceptArea,
            initialAngle: -0.4,
            isAccepted: _currentIndex == 0,
            onAccepted: () {
              setState(() {
                _currentIndex = 0;
              });
            },
          ),
          DragActionWidget(
            initialWidget: const Center(
              child: Text(
                '1',
                style: TextStyle(color: Colors.white, fontSize: 32),
              ),
            ),
            appliedWidget: const Center(
              child: Text(
                '"1"',
                style: TextStyle(color: Colors.pink, fontSize: 32),
              ),
            ),
            width: cardSize.width,
            height: cardSize.height,
            initialPosition: const Offset(310, 50),
            targetPosition: targetPosition,
            intoArea: acceptArea,
            initialAngle: 0.4,
            isAccepted: _currentIndex == 1,
            onAccepted: () {
              setState(() {
                _currentIndex = 1;
              });
            },
          ),
          DragActionWidget(
            initialWidget: Container(
                width: cardSize.width,
                height: cardSize.height,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text(
                    '2',
                    style: TextStyle(color: Colors.white, fontSize: 32),
                  ),
                )),
            appliedWidget: Container(
              width: cardSize.width,
              height: cardSize.height,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text(
                  '"2"',
                  style: TextStyle(color: Colors.white, fontSize: 32),
                ),
              ),
            ),
            width: cardSize.width,
            height: cardSize.height,
            initialPosition: const Offset(50, 400),
            targetPosition: targetPosition,
            intoArea: acceptArea,
            initialAngle: 0.2,
            isAccepted: _currentIndex == 2,
            onAccepted: () {
              setState(() {
                _currentIndex = 2;
              });
            },
          ),
        ],
      ),
    );
  }
}
