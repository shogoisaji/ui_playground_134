import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ui_playground_134/pages/follow_path/follow_path_widget.dart';
import 'package:ui_playground_134/utils/github_link.dart';

class FollowPathExample extends StatefulWidget {
  final String githubUrl;
  const FollowPathExample({super.key, required this.githubUrl});

  @override
  State<FollowPathExample> createState() => _FollowPathExampleState();
}

class _FollowPathExampleState extends State<FollowPathExample> {
  final PageController _pageController = PageController();
  final List<Map<String, dynamic>> pageData = [
    {
      'text': 'Home',
      'icon': Icon(Icons.home, color: Colors.grey.shade100, size: 30),
      'color': Colors.red,
    },
    {
      'text': 'Search',
      'icon': Icon(Icons.search, color: Colors.grey.shade100, size: 30),
      'color': Colors.blue,
    },
    {
      'text': 'Add',
      'icon': Icon(Icons.add, color: Colors.grey.shade100, size: 30),
      'color': Colors.green,
    },
    {
      'text': 'Favorite',
      'icon': Icon(Icons.favorite, color: Colors.grey.shade100, size: 30),
      'color': Colors.yellow,
    },
  ];

  bool _showOrbitPath = false;

  void handleTapItem(int index) {
    _pageController.animateToPage(index,
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              icon: const FaIcon(FontAwesomeIcons.github),
              onPressed: () async {
                await GithubLink.openGithubLink(widget.githubUrl);
              })
        ],
      ),
      body: Stack(
        children: [
          PageView(
            physics: const NeverScrollableScrollPhysics(),
            controller: _pageController,
            children: [
              for (final page in pageData)
                Container(
                  color: page['color'],
                  child: Center(
                    child: Text(
                      page['text'],
                      style: const TextStyle(color: Colors.white, fontSize: 60),
                    ),
                  ),
                ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: BottomNav(
              showOrbitPath: _showOrbitPath,
              onTapItem: (index) {
                handleTapItem(index);
              },
              pageData: pageData,
            ),
          ),
          _showPathButton()
        ],
      ),
    );
  }

  Widget _showPathButton() {
    return Positioned(
      top: 10,
      right: 10,
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            _showOrbitPath = !_showOrbitPath;
          });
        },
        child: const Text('show path'),
      ),
    );
  }
}

class BottomNav extends StatefulWidget {
  final List<Map<String, dynamic>> pageData;
  final bool showOrbitPath;
  final Function(int) onTapItem;
  const BottomNav(
      {super.key,
      required this.onTapItem,
      required this.showOrbitPath,
      required this.pageData});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> with TickerProviderStateMixin {
  final double _bottomNavigatorHeight = 80.0;
  final double _itemWidth = 50.0;

  List<Offset> _itemsPositionList = List.generate(4, (index) => Offset.zero);
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final w = MediaQuery.sizeOf(context).width;
      setState(() {
        _itemsPositionList = [
          Offset(w / 7, _bottomNavigatorHeight / 2),
          Offset(w * 2.4 / 7, _bottomNavigatorHeight / 2),
          Offset(w * 4.6 / 7, _bottomNavigatorHeight / 2),
          Offset(w * 6 / 7, _bottomNavigatorHeight / 2),
        ];
      });
    });
  }

  void handleTapItem(int index) {
    setState(() {
      _currentIndex = index;
    });
    widget.onTapItem(index);
  }

  Path createPath(double width, Offset position, int index) {
    const strength = 70.0;

    final p01 = Offset(position.dx, 0.8 * -strength);
    final p02 = Offset(position.dx + width / 5, 1.5 * -strength);
    final p03 = Offset(position.dx + width / 5, -_itemWidth / 2.2);

    final p04 = Offset(position.dx + width / 5, 0.7 * -strength);
    final p05 = Offset(width / 2, 1.5 * -strength);
    final p06 = Offset(width / 2, 0);

    final p11 = Offset(position.dx, 1.0 * -strength);
    final p12 = Offset(width / 2.3, -strength / 2);
    final p13 = Offset(width / 2.2, -_itemWidth / 2.8);

    final p14 = Offset(width / 2.1, -strength * 0.8);
    final p15 = Offset(width / 2, 0.3 * -strength);
    final p16 = Offset(width / 2, 0);

    final p21 = Offset(position.dx, 2.0 * -strength);
    final p22 = Offset(width / 2.3, -strength / 2);
    final p23 = Offset(width / 2.2, -_itemWidth / 2.8);

    final p24 = Offset(width / 2.1, -strength * 0.8);
    final p25 = Offset(width / 2, 1.5 * -strength);
    final p26 = Offset(width / 2, 0);

    final p31 = Offset(position.dx, 0.8 * -strength);
    final p32 = Offset(width - 20, -strength);
    final p33 = Offset(width - _itemWidth / 2.8, -strength);

    final p34 = Offset(width - _itemWidth / 2.8, -strength * 2);
    final p35 = Offset(width / 2, 1.5 * -strength);
    final p36 = Offset(width / 2, 0);

    final path = Path();
    path.moveTo(position.dx, position.dy);
    switch (index) {
      case 0:
        path.cubicTo(
          p01.dx,
          p01.dy,
          p02.dx,
          p02.dy,
          p03.dx,
          p03.dy,
        );
        path.cubicTo(
          p04.dx,
          p04.dy,
          p05.dx,
          p05.dy,
          p06.dx,
          p06.dy,
        );
        break;
      case 1:
        path.cubicTo(
          p11.dx,
          p11.dy,
          p12.dx,
          p12.dy,
          p13.dx,
          p13.dy,
        );
        path.cubicTo(
          p14.dx,
          p14.dy,
          p15.dx,
          p15.dy,
          p16.dx,
          p16.dy,
        );
        break;
      case 2:
        path.cubicTo(
          p21.dx,
          p21.dy,
          p22.dx,
          p22.dy,
          p23.dx,
          p23.dy,
        );
        path.cubicTo(
          p24.dx,
          p24.dy,
          p25.dx,
          p25.dy,
          p26.dx,
          p26.dy,
        );
        break;
      case 3:
        path.cubicTo(
          p31.dx,
          p31.dy,
          p32.dx,
          p32.dy,
          p33.dx,
          p33.dy,
        );
        path.cubicTo(
          p34.dx,
          p34.dy,
          p35.dx,
          p35.dy,
          p36.dx,
          p36.dy,
        );
        break;
    }
    return path;
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;

    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned(
          bottom: 0,
          child: CustomPaint(
            painter: _BottomNavStagePainter(
              itemWidth: _itemWidth,
              height: _bottomNavigatorHeight,
            ),
            size: Size(w, _bottomNavigatorHeight),
          ),
        ),
        ...widget.pageData.map((item) {
          final index = widget.pageData.indexOf(item);
          final path = createPath(w, _itemsPositionList[index], index).shift(
              Offset(-_itemsPositionList[index].dx,
                  -_itemsPositionList[index].dy));
          return Positioned(
            left: _itemsPositionList[index].dx,
            bottom: _itemsPositionList[index].dy,

            /// Custom Widget
            child: FollowPathWidget(
              path: path,
              isMove: _currentIndex == index,
              child: GestureDetector(
                onTap: () {
                  handleTapItem(index);
                },
                child: Container(
                  width: _itemWidth,
                  height: _itemWidth,
                  decoration: BoxDecoration(
                    color: Colors.orange.shade700,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        blurRadius: 3,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(child: item['icon']),
                ),
              ),
            ),
          );
        }),
        widget.showOrbitPath ? _buildOrbitPath(w) : const SizedBox.shrink(),
      ],
    );
  }

  Widget _buildOrbitPath(double w) {
    return Stack(children: [
      ...widget.pageData.map((item) {
        final index = widget.pageData.indexOf(item);
        return Positioned(
          bottom: 0,
          left: 0,
          child: IgnorePointer(
            child: CustomPaint(
              painter: _OrbitPainter(
                path: createPath(w, _itemsPositionList[index], index),
                color: (item['color'] as MaterialColor).shade800,
              ),
              size: Size(w, _bottomNavigatorHeight),
            ),
          ),
        );
      })
    ]);
  }
}

class _BottomNavStagePainter extends CustomPainter {
  const _BottomNavStagePainter({required this.itemWidth, required this.height});
  final double itemWidth;
  final double height;

  @override
  void paint(Canvas canvas, Size size) {
    const double itemWidthOffsetValue = 5;
    final paint = Paint()
      ..color = Colors.blue.shade900
      ..style = PaintingStyle.fill;

    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.5)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    final path = Path();
    path.moveTo(0, 2 * height);
    path.lineTo(0, height);
    path.lineTo(size.width / 2 - itemWidth / 2 - itemWidthOffsetValue, height);
    path.arcToPoint(
      Offset(size.width / 2 + itemWidth / 2 + itemWidthOffsetValue, height),
      radius: Radius.circular(itemWidth / 2 + itemWidthOffsetValue),
      clockwise: false,
    );
    path.lineTo(size.width, height);
    path.lineTo(size.width, 2 * height);
    path.close();

    canvas.drawPath(path.shift(Offset(0, -height)), shadowPaint);
    canvas.drawPath(path.shift(Offset(0, -height)), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class _OrbitPainter extends CustomPainter {
  const _OrbitPainter({required this.path, required this.color});
  final Path path;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
