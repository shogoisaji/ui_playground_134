import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ui_playground_134/pages/pull_window/card_model.dart';
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

  final List<CardModel> cardModels = [
    CardModel(
      beforeChild: const Center(
        child: Text('0',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
      ),
      afterChild: Container(
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(12),
        ),
        width: double.infinity,
        height: double.infinity,
      ),
      beforeWidth: cardSize.width,
      beforeHeight: cardSize.height,
      afterWidth: cardSize.width * 3,
      afterHeight: cardSize.height * 2,
      initialPosition: const Offset(120, 200),
      initialAngle: -0.4,
    ),
    CardModel(
      beforeChild: const Center(
        child: Text(
          '1',
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
      ),
      afterChild: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          'assets/images/sky.jpg',
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
        ),
      ),
      beforeWidth: cardSize.width,
      beforeHeight: cardSize.height,
      afterWidth: cardSize.width * 1.5,
      afterHeight: cardSize.height * 1.5,
      initialPosition: const Offset(390, 600),
      initialAngle: 0.2,
    ),
    CardModel(
      beforeChild: const Center(
        child: Text('2',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
      ),
      afterChild: Container(
        decoration: BoxDecoration(
          color: Colors.yellow,
          borderRadius: BorderRadius.circular(12),
        ),
        width: double.infinity,
        height: double.infinity,
      ),
      beforeWidth: cardSize.width * 0.6,
      beforeHeight: cardSize.height * 0.6,
      afterWidth: cardSize.width,
      afterHeight: cardSize.height,
      initialPosition: const Offset(30, 500),
      initialAngle: 0.7,
    ),
  ];

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
      backgroundColor: Colors.grey.shade700,
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
            cardModel: cardModels[0],
            targetPosition: targetPosition,
            intoAreaOffset: acceptArea,
            isAccepted: _currentIndex == 0,
            onAccepted: () {
              setState(() {
                _currentIndex = 0;
              });
            },
          ),
          DragActionWidget(
            cardModel: cardModels[1],
            targetPosition: targetPosition,
            intoAreaOffset: acceptArea,
            isAccepted: _currentIndex == 1,
            onAccepted: () {
              setState(() {
                _currentIndex = 1;
              });
            },
          ),
          DragActionWidget(
            cardModel: cardModels[2],
            targetPosition: targetPosition,
            intoAreaOffset: acceptArea,
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
