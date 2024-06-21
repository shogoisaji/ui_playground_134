import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_playground_134/pages/stripe_animation/stripe_animation_example.dart';

// 新しいpageを追加する場合は、pagesリストにMapを追加する
List<Map<String, dynamic>> pages = [
  {
    'name': 'stripe_animation',
    'page': const StripeAnimationExample(),
  },
];

GoRouter router() {
  final routes = [
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const ListPage();
      },
      routes: [
        ...List.generate(
          pages.length,
          (index) => GoRoute(
            path: '${pages[index]['name']}',
            builder: (BuildContext context, GoRouterState state) {
              return pages[index]['page'];
            },
          ),
        ),
      ],
    ),
  ];

  return GoRouter(
    initialLocation: '/',
    routes: routes,
  );
}

class ListPage extends StatelessWidget {
  const ListPage({super.key});

  @override
  Widget build(BuildContext context) {
    const breakpoint = 800;
    final w = MediaQuery.sizeOf(context).width;

    return Scaffold(
      backgroundColor: Colors.red[100],
      appBar: AppBar(
        backgroundColor: Colors.red[200],
        title: const Text('UI Playground 134',
            style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold)),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 500),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: pages.length,
                  itemBuilder: (context, index) => Card(
                    margin: const EdgeInsets.all(8),
                    color: Colors.pink[200],
                    child: InkWell(
                      onTap: () {
                        context.go('/${pages[index]['name']}');
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
                                    fontSize: w > breakpoint ? 24 : 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                child: Image.asset(
                                  'assets/images/thumbnails/${pages[index]['name']}.png',
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stack) {
                                    return Center(
                                      child: Text(
                                        'No Image',
                                        style: TextStyle(
                                            fontSize: 24,
                                            color: Colors.grey.shade700,
                                            fontWeight: FontWeight.bold),
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
    );
  }
}
