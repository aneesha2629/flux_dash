import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../core/app_colors.dart';

class AnimatedPieChart extends StatefulWidget {
  final List<double> data;
  final List<String> labels;

  const AnimatedPieChart({
    super.key,
    required this.data,
    required this.labels,
  });

  @override
  State<AnimatedPieChart> createState() => _AnimatedPieChartState();
}

class _AnimatedPieChartState extends State<AnimatedPieChart> {
  int _touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    if (widget.data.isEmpty) return const SizedBox.shrink();

    return Row(
      children: [
        Expanded(
          flex: 3,
          child: PieChart(
            PieChartData(
              sectionsSpace: 3,
              centerSpaceRadius: 28,
              pieTouchData: PieTouchData(
                touchCallback: (event, response) {
                  setState(() {
                    _touchedIndex =
                        response?.touchedSection?.touchedSectionIndex ?? -1;
                  });
                },
              ),
              sections: widget.data.asMap().entries.map((entry) {
                final isTouched = entry.key == _touchedIndex;
                final color = FluxColors.chartPalette[
                    entry.key % FluxColors.chartPalette.length];
                return PieChartSectionData(
                  value: entry.value,
                  color: color,
                  radius: isTouched ? 48 : 40,
                  title: '${entry.value.toStringAsFixed(1)}%',
                  titleStyle: TextStyle(
                    fontSize: isTouched ? 11 : 9,
                    fontWeight: FontWeight.w700,
                    color: FluxColors.bg01,
                  ),
                  borderSide: isTouched
                      ? BorderSide(color: color, width: 2)
                      : BorderSide.none,
                );
              }).toList(),
            ),
            swapAnimationDuration: const Duration(milliseconds: 600),
            swapAnimationCurve: Curves.easeOutCubic,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widget.labels.asMap().entries.map((entry) {
              final color = FluxColors.chartPalette[
                  entry.key % FluxColors.chartPalette.length];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        entry.value,
                        style: const TextStyle(
                          color: FluxColors.textSecondary,
                          fontSize: 10,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
