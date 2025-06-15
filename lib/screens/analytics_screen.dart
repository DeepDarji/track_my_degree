import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants.dart';
import '../providers/analytics_provider.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final assignmentStats = ref.watch(analyticsProvider).getAssignmentStats();
    final subjectStats = ref.watch(analyticsProvider).getSubjectStats();
    final subjectProgressData =
        ref.watch(analyticsProvider).getSubjectProgressData();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary Card
            Animate(
              effects: const [FadeEffect(), ScaleEffect()],
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(kDefaultPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Summary',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatCard(
                            'Subjects',
                            subjectStats['Total Subjects']
                                    ?.toInt()
                                    .toString() ??
                                '0',
                            kPrimaryBlue,
                          ),
                          _buildStatCard(
                            'Backlogs',
                            subjectStats['Backlogs']?.toInt().toString() ?? '0',
                            Colors.redAccent,
                          ),
                          _buildStatCard(
                            'Avg. Attendance',
                            '${subjectStats['Average Attendance']?.toStringAsFixed(0)}%',
                            kAccentGreen,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Assignment Pie Chart
            Text(
              'Assignment Status',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Animate(
              effects: const [
                FadeEffect(),
                SlideEffect(begin: Offset(0, 0.1), end: Offset.zero),
              ],
              child: SizedBox(
                height: 200,
                child:
                    assignmentStats['Completed'] == 0 &&
                            assignmentStats['Pending'] == 0
                        ? const Center(
                          child: Text(
                            'No assignments yet',
                            style: TextStyle(color: Colors.black54),
                          ),
                        )
                        : PieChart(
                          PieChartData(
                            sections: [
                              PieChartSectionData(
                                value: assignmentStats['Completed'],
                                color: kAccentGreen,
                                title: 'Completed',
                                titleStyle: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                              PieChartSectionData(
                                value: assignmentStats['Pending'],
                                color: kPrimaryBlue,
                                title: 'Pending',
                                titleStyle: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                            centerSpaceRadius: 40,
                            sectionsSpace: 2,
                          ),
                        ),
              ),
            ),
            const SizedBox(height: 16),

            // Subject Progress Bar Chart
            Text(
              'Subject Progress',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Animate(
              effects: const [
                FadeEffect(),
                SlideEffect(begin: Offset(0, 0.1), end: Offset.zero),
              ],
              child: SizedBox(
                height: 250,
                child:
                    subjectProgressData.isEmpty
                        ? const Center(
                          child: Text(
                            'No subjects yet',
                            style: TextStyle(color: Colors.black54),
                          ),
                        )
                        : BarChart(
                          BarChartData(
                            alignment: BarChartAlignment.spaceAround,
                            maxY: 100,
                            barGroups:
                                subjectProgressData
                                    .asMap()
                                    .entries
                                    .map(
                                      (entry) => BarChartGroupData(
                                        x: entry.key,
                                        barRods: [
                                          BarChartRodData(
                                            toY:
                                                entry.value['attendance']
                                                    ?.toDouble() ??
                                                0,
                                            color: kPrimaryBlue,
                                            width: 15,
                                            borderRadius:
                                                const BorderRadius.vertical(
                                                  top: Radius.circular(4),
                                                ),
                                          ),
                                        ],
                                      ),
                                    )
                                    .toList(),
                            titlesData: FlTitlesData(
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 40,
                                  getTitlesWidget:
                                      (value, meta) =>
                                          Text('${value.toInt()}%'),
                                ),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget:
                                      (value, meta) => Text(
                                        subjectProgressData[value
                                                .toInt()]['name']
                                            .toString()
                                            .substring(0, 3),
                                        style: const TextStyle(fontSize: 10),
                                      ),
                                ),
                              ),
                              topTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              rightTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                            ),
                            gridData: const FlGridData(show: false),
                            borderData: FlBorderData(show: false),
                          ),
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          title,
          style: const TextStyle(fontSize: 14, color: Colors.black54),
        ),
      ],
    );
  }
}
