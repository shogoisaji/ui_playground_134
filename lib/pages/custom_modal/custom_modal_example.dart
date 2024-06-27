import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ui_playground_134/pages/custom_modal/custom_modal_widget.dart';
import 'package:ui_playground_134/utils/github_link.dart';

const List<Color> contentColors = [Colors.red, Colors.blue, Colors.green];

class CustomModalExample extends StatefulWidget {
  final String githubUrl;
  const CustomModalExample({super.key, required this.githubUrl});

  @override
  State<CustomModalExample> createState() => _CustomModalExampleState();
}

class _CustomModalExampleState extends State<CustomModalExample> {
  bool _isLoading = false;
  int _selectedIndex = 0;
  final List<Image> _imageList = [];

  final contents = List.generate(
      3, (index) => "https://picsum.photos/200/300?random=$index");

  void showModal() {
    Navigator.of(context).push(CustomModal(
      selectedIndex: _selectedIndex,
      imageList: _imageList,
      onSetIndex: _handleSetIndex,
    ));
  }

  void _handleSetIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.of(context).pop();
  }

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber.shade100,
      appBar: AppBar(
        actions: [
          IconButton(
              icon: const FaIcon(FontAwesomeIcons.github),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              onPressed: () async {
                await GithubLink.openGithubLink(widget.githubUrl);
              })
        ],
      ),
      body: Center(
        child: GestureDetector(
          onTap: () {
            if (_imageList.isEmpty) return;
            showModal();
          },
          child: ContentWidget(
            image: _imageList.isNotEmpty ? _imageList[_selectedIndex] : null,
            isLoading: _isLoading,
            color: contentColors[_selectedIndex % contentColors.length],
            index: _selectedIndex,
          ),
        ),
      ),
    );
  }
}
