import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_playground_134/pages/deform_cloud/deform_cloud_example.dart';
import 'package:ui_playground_134/pages/follow_path/follow_path_example.dart';
import 'package:ui_playground_134/pages/home_page.dart';
import 'package:ui_playground_134/pages/level_gauge/level_gauge_example.dart';
import 'package:ui_playground_134/pages/particle_hole/particle_hole_example.dart';

import 'package:ui_playground_134/pages/stripe_animation/stripe_animation_example.dart';

// 新しいpageを追加する場合は、pagesリストにMapを追加する
List<Map<String, dynamic>> pages = [
  {
    'name': 'level_gauge',
    'page': const LevelGaugeExample(
      githubUrl:
          'https://github.com/shogoisaji/ui_playground_134/blob/main/lib/pages/level_gauge/level_gauge_example.dart',
    ),
    'date': DateTime(2024, 6, 26),
    'thumbnail': 'level_gauge.gif',
  },
  {
    'name': 'deform_cloud',
    'page': const DeformCloudExample(
      githubUrl:
          'https://github.com/shogoisaji/ui_playground_134/blob/main/lib/pages/deform_cloud/deform_cloud_example.dart',
    ),
    'date': DateTime(2024, 6, 25),
    'thumbnail': 'deform_cloud.gif',
  },
  {
    'name': 'particle_hole',
    'page': const ParticleHoleExample(
      githubUrl:
          'https://github.com/shogoisaji/ui_playground_134/blob/main/lib/pages/particle_hole/particle_hole_expample.dart',
    ),
    'date': DateTime(2024, 6, 24),
    'thumbnail': 'particle_hole.gif',
  },
  {
    'name': 'follow_path',
    'page': const FollowPathExample(
      githubUrl:
          'https://github.com/shogoisaji/ui_playground_134/blob/main/lib/pages/follow_path/follow_path_example.dart',
    ),
    'date': DateTime(2024, 6, 23),
    'thumbnail': 'follow_path.gif',
  },
  {
    'name': 'stripe_animation',
    'page': const StripeAnimationExample(
      githubUrl:
          'https://github.com/shogoisaji/ui_playground_134/blob/main/lib/pages/stripe_animation/stripe_animation_example.dart',
    ),
    'date': DateTime(2024, 6, 21),
    'thumbnail': 'stripe_animation.gif',
  },
];

GoRouter router() {
  final routes = [
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const HomePage(
          githubUrl: 'https://github.com/shogoisaji/ui_playground_134/',
        );
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
