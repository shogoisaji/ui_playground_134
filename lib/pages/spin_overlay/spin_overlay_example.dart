import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ui_playground_134/pages/spin_overlay/selected_spin_widget.dart';
import 'package:ui_playground_134/pages/spin_overlay/selected_zoom_widget.dart';
import 'package:ui_playground_134/utils/open_link.dart';

enum OverlayType {
  spin,
  zoom,
}

class SpinOverlayExample extends StatefulWidget {
  final String githubUrl;
  const SpinOverlayExample({super.key, required this.githubUrl});

  @override
  State<SpinOverlayExample> createState() => _SpinOverlayExampleState();
}

class _SpinOverlayExampleState extends State<SpinOverlayExample> {
  OverlayType selectedType = OverlayType.spin;

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
      body: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _typeSelector(selectedType, OverlayType.spin,
                    (value) => setState(() => selectedType = value)),
                const SizedBox(width: 12),
                _typeSelector(selectedType, OverlayType.zoom,
                    (value) => setState(() => selectedType = value)),
              ],
            ),
          ),
          Expanded(
            child: SizedBox(
              width: double.infinity,
              child: ListView.builder(
                itemCount: 20,
                itemBuilder: (context, index) {
                  return switch (selectedType) {
                    OverlayType.spin => SelectedSpinWidget(
                        index: index,
                        imageLink:
                            'https://picsum.photos/200/300?random=$index',
                      ),
                    OverlayType.zoom => SelectedZoomWidget(
                        index: index,
                        imageLink:
                            'https://picsum.photos/200/300?random=$index',
                      ),
                  };
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _typeSelector(OverlayType selectedType, OverlayType overlayType,
      Function(OverlayType) onChanged) {
    return GestureDetector(
      onTap: () {
        if (selectedType != overlayType) {
          onChanged(overlayType);
        }
      },
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: selectedType != overlayType
                ? Colors.grey.shade100
                : Colors.orange.shade500,
            border: Border.all(color: Colors.grey.shade700, width: 1.5),
            borderRadius: BorderRadius.circular(99),
          ),
          child: switch (overlayType) {
            OverlayType.spin => Text('Spin',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.grey.shade800)),
            OverlayType.zoom => Text('Zoom',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.grey.shade800)),
          }),
    );
  }
}
