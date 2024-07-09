import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ui_playground_134/pages/smooth_nav/dog_data.dart';
import 'package:ui_playground_134/pages/smooth_nav/dog_detail_page.dart';
import 'package:ui_playground_134/utils/open_link.dart';

/// This widget has the same usage as the Hero widget
/// https://api.flutter.dev/flutter/widgets/Hero-class.html
///
class SmoothNavExample extends StatefulWidget {
  final String githubUrl;
  const SmoothNavExample({super.key, required this.githubUrl});

  @override
  State<SmoothNavExample> createState() => _SmoothNavExampleState();
}

class _SmoothNavExampleState extends State<SmoothNavExample> {
  final List<DogData> _dogDataList = [];
  bool _isLoading = false;

  static const listCount = 5;

  void _dogListGenerate() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final data = await DogData.createData(listCount);
      _dogDataList.addAll(data);
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _dogListGenerate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(99)),
                  padding: const EdgeInsets.symmetric(
                      vertical: 6.0, horizontal: 20.0),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Text('Dog List',
                      style: TextStyle(
                        fontSize: 32,
                        color: Colors.blue.shade900,
                        fontWeight: FontWeight.bold,
                      )),
                ),
                const Text(
                  '※写真はランダム',
                ),
                Expanded(
                  child: SizedBox(
                    child: ListView.builder(
                      itemCount: _dogDataList.length,
                      itemBuilder: (context, index) {
                        return _ListContent(dogData: _dogDataList[index]);
                      },
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class _ListContent extends StatefulWidget {
  final DogData dogData;

  const _ListContent({super.key, required this.dogData});

  @override
  _ListContentState createState() => _ListContentState();
}

class _ListContentState extends State<_ListContent> {
  final GlobalKey _imageKey = GlobalKey();

  Route _smoothRoute(Widget prevWidget, DogData dogData) {
    final RenderBox box =
        _imageKey.currentContext!.findRenderObject() as RenderBox;
    final prevSize = box.size;
    final prevPosition = box.localToGlobal(Offset.zero);
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 300),
      reverseTransitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, animation, secondaryAnimation) =>
          DogDetailPage(dogData: dogData),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final size = MediaQuery.sizeOf(context);
        final scaleX =
            Tween<double>(begin: prevSize.width / size.width, end: 1);
        final scaleY =
            Tween<double>(begin: prevSize.height / size.width, end: 1);
        final topPosition = Tween<double>(begin: prevPosition.dy, end: 0);
        final leftPosition = Tween<double>(begin: prevPosition.dx, end: 0);
        return animation.value == 1
            ? child
            : Stack(
                children: [
                  _buildAnimatedChild(animation, topPosition, leftPosition,
                      scaleX, scaleY, child),
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
    final Animation<double> customAnimation =
        CurvedAnimation(parent: animation, curve: Curves.easeInOut);
    return Positioned(
      top: topPosition.animate(customAnimation).value,
      left: leftPosition.animate(customAnimation).value,
      child: Transform.scale(
        alignment: Alignment.topLeft,
        scaleX: scaleX.animate(customAnimation).value,
        scaleY: scaleY.animate(customAnimation).value,
        child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: child),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .push(_smoothRoute(widget.dogData.image, widget.dogData));
      },

      /// use Hero
      ///
      // onTap: () {
      //   Navigator.of(context).push(MaterialPageRoute(
      //     builder: (context) => DogDetailPage(dogData: widget.dogData),
      //   ));
      // },
      child: Align(
        child: Container(
          width: w * 0.9,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                key: _imageKey,
                borderRadius: BorderRadius.circular(10),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: widget.dogData.image,
                ),
              ),

              /// use Hero
              // Hero(
              //   tag: widget.dogData.name,
              //   child: ClipRRect(
              //     key: _imageKey,
              //     borderRadius: BorderRadius.circular(10),
              //     child: AspectRatio(
              //       aspectRatio: 1,
              //       child: widget.dogData.image,
              //     ),
              //   ),
              // ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.dogData.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          size: 20,
                        ),
                        Text(
                          widget.dogData.rating.toString(),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.dogData.description,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
