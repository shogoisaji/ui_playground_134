import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ui_playground_134/pages/m_line_chart/chart_data.dart';
import 'package:ui_playground_134/pages/m_line_chart/chart_widget.dart';
import 'package:ui_playground_134/utils/open_link.dart';

class MLineChartExample extends StatefulWidget {
  final String githubUrl;
  const MLineChartExample({super.key, required this.githubUrl});

  @override
  State<MLineChartExample> createState() => _MLineChartExampleState();
}

class _MLineChartExampleState extends State<MLineChartExample> {
  static const maxWidth = 700.0;

  Future<List<ChartData>> fetchChartData() async {
    try {
      final jsonString =
          await rootBundle.loadString('lib/pages/m_line_chart/data.json');
      final jsonData = json.decode(jsonString) as List;
      return jsonData.map((item) => ChartData.fromJson(item)).toList();
    } catch (e) {
      print('エラー: $e');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade300,
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
      body: Center(
        child: FutureBuilder<List<ChartData>>(
          future: fetchChartData(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return _buildChart(w, snapshot.data!);
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  Widget _buildChart(double w, List<ChartData> data) {
    return ChartWidget(
      width: (w * 0.8).clamp(0, maxWidth),
      height: 300,
      data: data,
    );
  }
}
