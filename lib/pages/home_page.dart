import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_playground_134/routes/router.dart';
import 'package:ui_playground_134/strings.dart';
import 'package:ui_playground_134/utils/open_link.dart';

class HomePage extends StatefulWidget {
  final String githubUrl;
  const HomePage({super.key, required this.githubUrl});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isMobile = false;
  int? _hoverIndex;

  void detectDevice() {
    String userAgent = html.window.navigator.userAgent.toLowerCase();
    if (userAgent.contains('iphone') || userAgent.contains('ipad')) {
      _isMobile = true;
    } else if (userAgent.contains('android')) {
      _isMobile = true;
    } else {
      // print('その他のデバイスです');
    }
  }

  @override
  void initState() {
    super.initState();
    detectDevice();
  }

  @override
  Widget build(BuildContext context) {
    const breakpoint = 800;
    final w = MediaQuery.sizeOf(context).width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF01579B),
        title: Image.asset(
          'assets/images/logo.png',
          width: (w * 0.6).clamp(0, 400),
        ),
        actions: [
          IconButton(
              icon: FaIcon(
                FontAwesomeIcons.github,
                color: Colors.blue.shade50,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              onPressed: () async {
                await OpenLink.open(widget.githubUrl);
              })
        ],
      ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: const Alignment(-0.0, 0.0),
                end: const Alignment(0.5, 0.9),
                colors: [
                  const Color(0xFF01579B),
                  Colors.blue.shade200,
                ],
              ),
            ),
          ),
          Align(
            alignment: const Alignment(0.9, 0.95),
            child: Opacity(
              opacity: 0.5,
              child: Image.asset(
                'assets/images/character.png',
                fit: BoxFit.contain,
                width: w / 2,
              ),
            ),
          ),
          Center(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 300,
                  childAspectRatio: 1.0,
                ),
                itemCount: pages.length + 2,
                itemBuilder: (context, index) => index > pages.length - 1
                    ? const SizedBox.shrink()
                    : Card(
                        margin: const EdgeInsets.only(
                            top: 16, bottom: 0, left: 8, right: 8),
                        elevation: 6,
                        color: const Color(0xFF54C5F8),
                        child: MouseRegion(
                          onHover: (_) {
                            if (_isMobile) return;
                            setState(() {
                              _hoverIndex = index;
                            });
                          },
                          onExit: (_) {
                            if (_isMobile) return;
                            setState(() {
                              _hoverIndex = null;
                            });
                          },
                          child: GestureDetector(
                            onTap: () {
                              context.go('/${pages[index]['name']}',
                                  extra: pages[index]['github']);
                            },
                            child: Column(
                              children: [
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 3.0,
                                        bottom: 0.0,
                                        left: 4.0,
                                        right: 4.0),
                                    child: Text(
                                      '${pages[index]['name'].split('_').map((word) {
                                        final String w = word;
                                        return w.capitalize();
                                      }).join(' ')}',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: Colors.grey[800],
                                          fontSize: w > breakpoint ? 24 : 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.only(
                                        top: 2, bottom: 6, left: 6, right: 6),
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 5.0, horizontal: 6.0),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade50,
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.3),
                                          blurRadius: 3,
                                          offset: const Offset(0, 1),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      children: [
                                        Text(
                                          (pages[index]['date'] as DateTime)
                                              .toIso8601String()
                                              .toYMDString(),
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: Colors.grey[500],
                                            fontSize: 14,
                                          ),
                                        ),
                                        Expanded(
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            child: RepaintBoundary(
                                              child: SizedBox(
                                                width: double.infinity,
                                                child: index == _hoverIndex
                                                    ? Image.asset(
                                                        'assets/animated_thumbnails/${pages[index]['name']}.webp',
                                                        fit: BoxFit.cover,
                                                        errorBuilder: (context,
                                                            error, stack) {
                                                          return Image.asset(
                                                            'assets/thumbnails/${pages[index]['name']}.png',
                                                            fit: BoxFit.cover,
                                                            errorBuilder:
                                                                (context, error,
                                                                    stack) {
                                                              return _errorImage();
                                                            },
                                                          );
                                                        },
                                                      )
                                                    : Image.asset(
                                                        'assets/thumbnails/${pages[index]['name']}.png',
                                                        fit: BoxFit.cover,
                                                        errorBuilder: (context,
                                                            error, stack) {
                                                          return _errorImage();
                                                        },
                                                      ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _errorImage() {
    return Center(
      child: Text(
        'No Image',
        style: TextStyle(
            fontSize: 24,
            color: Colors.grey.shade700,
            fontWeight: FontWeight.bold),
      ),
    );
  }
}
