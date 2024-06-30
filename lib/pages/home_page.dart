import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_playground_134/routes/router.dart';
import 'package:ui_playground_134/strings.dart';
import 'package:ui_playground_134/utils/open_link.dart';

class HomePage extends StatelessWidget {
  final String githubUrl;
  const HomePage({super.key, required this.githubUrl});

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
                await OpenLink.open(githubUrl);
              })
        ],
      ),
      body: Stack(
        children: [
          Align(
            alignment: const Alignment(0.9, 0.9),
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
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 1000),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 300,
                        childAspectRatio: 1.0,
                      ),
                      itemCount: pages.length + 2,
                      itemBuilder: (context, index) => index > pages.length - 1
                          ? const SizedBox.shrink()
                          : Card(
                              margin: const EdgeInsets.all(8),
                              elevation: 8,
                              color: const Color(0xFF54C5F8),
                              child: InkWell(
                                onTap: () {
                                  context.go('/${pages[index]['name']}',
                                      extra: pages[index]['github']);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Center(
                                        child: Text(
                                          '${pages[index]['name']}',
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: Colors.grey[800],
                                              fontSize:
                                                  w > breakpoint ? 24 : 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: Text(
                                          (pages[index]['date'] as DateTime)
                                              .toIso8601String()
                                              .toYMDString(),
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: Colors.grey[800],
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          padding: const EdgeInsets.all(8),
                                          child: Image.asset(
                                            'assets/thumbnails/${pages[index]['thumbnail']}',
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stack) {
                                              return Center(
                                                child: Text(
                                                  'No Image',
                                                  style: TextStyle(
                                                      fontSize: 24,
                                                      color:
                                                          Colors.grey.shade700,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              );
                                            },
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
          ),
        ],
      ),
    );
  }
}
