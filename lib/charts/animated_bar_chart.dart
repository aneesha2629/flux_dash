import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../core/app_colors.dart';

class AnimatedBarChart extends StatefulWidget {
  final List<double> data;
  final List<String> labels;
  final Color color;

  const AnimatedBarChart({
    super.key,
    required this.data,
    required this.labels,
    required this.color,
  });

  @override
  State<AnimatedBarChart> createState() => _AnimatedBarChartState();
}

class _AnimatedBarChartState extends State<AnimatedBarChart> {
  int _touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    if (widget.data.isEmpty) return const SizedBox.shrink();

    final maxY = widget.data.reduce((a, b) => a > b ? a : b) * 1.25;

    return BarChart(
      BarChartData(
        maxY: maxY,
        barTouchData: BarTouchData(
          enabled: true,
          touchCallback: (event, response) {
            setState(() {
              _touchedIndex = response?.spot?.touchedBarGroupIndex ?? -1;
            });
          },
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (_) => FluxColors.bg03,
            tooltipRoundedRadius: 8,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                rod.toY.toStringAsFixed(0),
                TextStyle(
                  color: widget.color,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 24,
              getTitlesWidget: (value, meta) {
                final idx = value.toInt();
                if (idx < 0 || idx >= widget.labels.length) return const SizedBox.shrink();
                return Text(
                  widget.labels[idx],
                  style: const TextStyle(
                    color: FluxColors.textMuted,
                    fontSize: 10,
                  ),
                );
              },
            ),
          ),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) => const FlLine(
            color: FluxColors.bg04,
            strokeWidth: 1,
            dashArray: [4, 4],
          ),
        ),
        borderData: FlBorderData(show: false),
        barGroups: widget.data.asMap().entries.map((entry) {
          final isTouched = entry.key == _touchedIndex;
          return BarChartGroupData(
            x: entry.key,
            barRods: [
              BarChartRodData(
                toY: entry.value,
                width: 14,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                gradient: LinearGradient(
                  colors: [
                    widget.color.withOpacity(isTouched ? 1.0 : 0.7),
                    widget.color,
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
                backDrawRodData: BackgroundBarChartRodData(
                  show: true,
                  toY: maxY,
                  color: FluxColors.bg04.withOpacity(0.3),
                ),
              ),
            ],
          );
        }).toList(),
      ),
      swapAnimationDuration: const Duration(milliseconds: 600),
      swapAnimationCurve: Curves.easeOutCubic,
    );
  }
}
