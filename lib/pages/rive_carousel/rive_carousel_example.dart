import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ui_playground_134/pages/rive_carousel/rive_widget.dart';
import 'package:ui_playground_134/utils/open_link.dart';

class RiveCarouselExample extends StatefulWidget {
  final String githubUrl;
  const RiveCarouselExample({super.key, required this.githubUrl});

  @override
  State<RiveCarouselExample> createState() => _RiveCarouselExampleState();
}

class _RiveCarouselExampleState extends State<RiveCarouselExample> {
  static const _riveLink =
      "https://rive.app/community/files/11344-21686-character";
  bool _isLoading = false;
  double _walkValue = 0;
  final List<Image> _imageList = [];

  final ScrollController _listViewController = ScrollController();

  final contents = List.generate(
      5, (index) => "https://picsum.photos/200/300?random=$index");

  Future<void> _preloadImages() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final loadedImages = await Future.wait(
        contents.map((url) async {
          final imageProvider = NetworkImage(url);
          await precacheImage(imageProvider, context);
          return Image(image: imageProvider, fit: BoxFit.cover);
        }),
      );
      setState(() {
        _imageList.addAll(loadedImages);
      });
    } catch (e) {
      print('error');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _preloadImages();
    });

    _listViewController.addListener(() {
      setState(() {
        _walkValue = _listViewController.offset % 100;
      });
    });
  }

  @override
  void dispose() {
    _listViewController.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade800,
      appBar: AppBar(
        actions: [
          IconButton(
              icon: SvgPicture.asset(
                "assets/images/rive_icon.svg",
                width: 24,
                height: 24,
                colorFilter:
                    ColorFilter.mode(Colors.grey.shade800, BlendMode.srcIn),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              onPressed: () async {
                await OpenLink.open(_riveLink);
              }),
          IconButton(
              icon: const FaIcon(FontAwesomeIcons.github),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              onPressed: () async {
                await OpenLink.open(widget.githubUrl);
              }),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.grey.shade600,
          width: MediaQuery.sizeOf(context).width,
          height: 300,
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                  cacheExtent: double.infinity,
                  controller: _listViewController,
                  scrollDirection: Axis.horizontal,
                  children: _imageList
                      .map((image) => RiveWidget(
                            walkValue: _walkValue,
                            image: image,
                          ))
                      .toList(),
                ),
        ),
      ),
    );
  }
}
