import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../core/app_colors.dart';

class AnimatedLineChart extends StatelessWidget {
  final List<double> data;
  final List<String> labels;
  final Color color;
  final bool showGradient;
  final bool isArea;

  const AnimatedLineChart({
    super.key,
    required this.data,
    required this.labels,
    required this.color,
    this.showGradient = true,
    this.isArea = false,
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return const SizedBox.shrink();

    final spots = data.asMap().entries
        .map((e) => FlSpot(e.key.toDouble(), e.value))
        .toList();

    final maxY = data.reduce((a, b) => a > b ? a : b) * 1.2;
    final minY = data.reduce((a, b) => a < b ? a : b) * 0.8;

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: (maxY - minY) / 4,
          getDrawingHorizontalLine: (value) => FlLine(
            color: FluxColors.bg04.withOpacity(0.5),
            strokeWidth: 1,
            dashArray: [4, 4],
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
              interval: (data.length / 4).ceil().toDouble(),
              getTitlesWidget: (value, meta) {
                final idx = value.toInt();
                if (idx < 0 || idx >= labels.length) {
                  return const SizedBox.shrink();
                }
                return Text(
                  labels[idx],
                  style: const TextStyle(
                    color: FluxColors.textMuted,
                    fontSize: 10,
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: (data.length - 1).toDouble(),
        minY: minY,
        maxY: maxY,
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            curveSmoothness: 0.35,
            color: color,
            barWidth: 2.5,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: index == data.length - 1 ? 4 : 0,
                  color: color,
                  strokeWidth: 2,
                  strokeColor: FluxColors.bg02,
                );
              },
            ),
            belowBarData: isArea
                ? BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      colors: [
                        color.withOpacity(0.3),
                        color.withOpacity(0.0),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  )
                : BarAreaData(show: false),
          ),
        ],
        lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (_) => FluxColors.bg03,
            tooltipRoundedRadius: 8,
            getTooltipItems: (spots) => spots.map((spot) {
              return LineTooltipItem(
                spot.y.toStringAsFixed(1),
                TextStyle(
                  color: color,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              );
            }).toList(),
          ),
        ),
      ),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
    );
  }
}
