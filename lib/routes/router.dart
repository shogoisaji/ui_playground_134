import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ui_playground_134/pages/scaleup_nav/scaleup_nav_example.dart';
import 'package:ui_playground_134/pages/deform_cloud/deform_cloud_example.dart';
import 'package:ui_playground_134/pages/follow_path/follow_path_example.dart';
import 'package:ui_playground_134/pages/home_page.dart';
import 'package:ui_playground_134/pages/level_gauge/level_gauge_example.dart';
import 'package:ui_playground_134/pages/custom_modal/custom_modal_example.dart';
import 'package:ui_playground_134/pages/m_line_chart/m_line_chart_example.dart';
import 'package:ui_playground_134/pages/particle_hole/particle_hole_example.dart';
import 'package:ui_playground_134/pages/rive_carousel/rive_carousel_example.dart';
import 'package:ui_playground_134/pages/rive_power/rive_power_example.dart';
import 'package:ui_playground_134/pages/smooth_nav/smooth_nav_example.dart';
import 'package:ui_playground_134/pages/spin_overlay/spin_overlay_example.dart';

import 'package:ui_playground_134/pages/stripe_animation/stripe_animation_example.dart';
import 'package:ui_playground_134/pages/volume_controller/volume_controller_example.dart';

// 新しいpageを追加する場合は、pagesリストにMapを追加する
List<Map<String, dynamic>> pages = [
  {
    'name': 'smooth_nav',
    'page': const SmoothNavExample(
      githubUrl:
          'https://github.com/shogoisaji/ui_playground_134/blob/main/lib/pages/smooth_nav/smooth_nav_example.dart',
    ),
    'date': DateTime(2024, 7, 9),
    'thumbnail': 'smooth_nav.webp',
  },
  {
    'name': 'scaleup_nav',
    'page': const ScaleupNavExample(
      githubUrl:
          'https://github.com/shogoisaji/ui_playground_134/blob/main/lib/pages/scaleup_nav/scaleup_nav_example.dart',
    ),
    'date': DateTime(2024, 7, 5),
    'thumbnail': 'scaleup_nav.webp',
  },
  {
    'name': 'spin_overlay',
    'page': const SpinOverlayExample(
      githubUrl:
          'https://github.com/shogoisaji/ui_playground_134/blob/main/lib/pages/spin_overlay/spin_overlay_example.dart',
    ),
    'date': DateTime(2024, 7, 4),
    'thumbnail': 'spin_overlay.webp',
  },
  {
    'name': 'rive_power',
    'page': const RivePowerExample(
      githubUrl:
          'https://github.com/shogoisaji/ui_playground_134/blob/main/lib/pages/rive_power/rive_power_example.dart',
    ),
    'date': DateTime(2024, 7, 3),
    'thumbnail': 'rive_power.webp',
  },
  {
    'name': 'volume_controller',
    'page': const VolumeControllerExample(
      githubUrl:
          'https://github.com/shogoisaji/ui_playground_134/blob/main/lib/pages/volume_controller/volume_controller_example.dart',
    ),
    'date': DateTime(2024, 7, 2),
    'thumbnail': 'volume_controller.webp',
  },
  {
    'name': 'rive_carousel',
    'page': const RiveCarouselExample(
      githubUrl:
          'https://github.com/shogoisaji/ui_playground_134/blob/main/lib/pages/rive_carousel/rive_carousel_example.dart',
    ),
    'date': DateTime(2024, 6, 30),
    'thumbnail': 'rive_carousel.webp',
  },
  {
    'name': 'm_line_chart',
    'page': const MLineChartExample(
      githubUrl:
          'https://github.com/shogoisaji/ui_playground_134/blob/main/lib/pages/m_line_chart/m_line_chart_example.dart',
    ),
    'date': DateTime(2024, 6, 28),
    'thumbnail': 'm_line_chart.webp',
  },
  {
    'name': 'custom_modal',
    'page': const CustomModalExample(
      githubUrl:
          'https://github.com/shogoisaji/ui_playground_134/blob/main/lib/pages/custom_modal/custom_modal_example.dart',
    ),
    'date': DateTime(2024, 6, 27),
    'thumbnail': 'custom_modal.webp',
  },
  {
    'name': 'level_gauge',
    'page': const LevelGaugeExample(
      githubUrl:
          'https://github.com/shogoisaji/ui_playground_134/blob/main/lib/pages/level_gauge/level_gauge_example.dart',
    ),
    'date': DateTime(2024, 6, 26),
    'thumbnail': 'level_gauge.webp',
  },
  {
    'name': 'deform_cloud',
    'page': const DeformCloudExample(
      githubUrl:
          'https://github.com/shogoisaji/ui_playground_134/blob/main/lib/pages/deform_cloud/deform_cloud_example.dart',
    ),
    'date': DateTime(2024, 6, 25),
    'thumbnail': 'deform_cloud.webp',
  },
  {
    'name': 'particle_hole',
    'page': const ParticleHoleExample(
      githubUrl:
          'https://github.com/shogoisaji/ui_playground_134/blob/main/lib/pages/particle_hole/particle_hole_expample.dart',
    ),
    'date': DateTime(2024, 6, 24),
    'thumbnail': 'particle_hole.webp',
  },
  {
    'name': 'follow_path',
    'page': const FollowPathExample(
      githubUrl:
          'https://github.com/shogoisaji/ui_playground_134/blob/main/lib/pages/follow_path/follow_path_example.dart',
    ),
    'date': DateTime(2024, 6, 23),
    'thumbnail': 'follow_path.webp',
  },
  {
    'name': 'stripe_animation',
    'page': const StripeAnimationExample(
      githubUrl:
          'https://github.com/shogoisaji/ui_playground_134/blob/main/lib/pages/stripe_animation/stripe_animation_example.dart',
    ),
    'date': DateTime(2024, 6, 21),
    'thumbnail': 'stripe_animation.webp',
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
    errorBuilder: (context, state) => ErrorPage(error: state.error),
    redirect: (context, state) {
      return null;
    },
  );
}

class ErrorPage extends StatelessWidget {
  final Exception? error;
  const ErrorPage({super.key, this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('エラー')),
      body: Center(child: Text('エラーが発生しました: ${error.toString()}')),
    );
  }
}
