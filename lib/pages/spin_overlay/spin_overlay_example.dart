import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ui_playground_134/pages/spin_overlay/selected_spin_widget.dart';
import 'package:ui_playground_134/utils/open_link.dart';

class SpinOverlayExample extends StatefulWidget {
  final String githubUrl;
  const SpinOverlayExample({super.key, required this.githubUrl});

  @override
  State<SpinOverlayExample> createState() => _SpinOverlayExampleState();
}

class _SpinOverlayExampleState extends State<SpinOverlayExample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink.shade100,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
        actions: [
          IconButton(
              icon: const FaIcon(FontAwesomeIcons.github),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              onPressed: () async {
                await OpenLink.open(widget.githubUrl);
              })
        ],
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: ListView.builder(
          itemCount: 20,
          itemBuilder: (context, index) {
            return SelectedSpinWidget(
              index: index,
              imageLink: 'https://picsum.photos/200/300?random=$index',
            );
          },
        ),
      ),
    );
  }
}
