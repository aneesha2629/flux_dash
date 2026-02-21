import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../core/app_constants.dart';

enum CardType { line, bar, pie, stat, area }
enum TrendDirection { up, down, flat }

class ChartDataPoint {
  final double value;
  final String label;
  const ChartDataPoint({required this.value, required this.label});
}

class DashboardCardModel {
  final String id;
  final String title;
  final String subtitle;
  final CardType type;
  final Color accentColor;
  final IconData icon;
  int gridPosition;
  bool isExpanded;
  List<double> seriesData;
  List<String> seriesLabels;
  double currentValue;
  double previousValue;
  String unit;
  List<String> legendLabels;
  List<double> pieData;

  DashboardCardModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.type,
    required this.accentColor,
    required this.icon,
    required this.gridPosition,
    this.isExpanded = false,
    required this.seriesData,
    required this.seriesLabels,
    required this.currentValue,
    required this.previousValue,
    this.unit = '',
    this.legendLabels = const [],
    this.pieData = const [],
  });

  double get trendPercent {
    if (previousValue == 0) return 0;
    return ((currentValue - previousValue) / previousValue) * 100;
  }

  TrendDirection get trendDirection {
    if (trendPercent > 0.5) return TrendDirection.up;
    if (trendPercent < -0.5) return TrendDirection.down;
    return TrendDirection.flat;
  }

  DashboardCardModel copyWith({
    String? id,
    String? title,
    String? subtitle,
    CardType? type,
    Color? accentColor,
    IconData? icon,
    int? gridPosition,
    bool? isExpanded,
    List<double>? seriesData,
    List<String>? seriesLabels,
    double? currentValue,
    double? previousValue,
    String? unit,
    List<String>? legendLabels,
    List<double>? pieData,
  }) {
    return DashboardCardModel(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      type: type ?? this.type,
      accentColor: accentColor ?? this.accentColor,
      icon: icon ?? this.icon,
      gridPosition: gridPosition ?? this.gridPosition,
      isExpanded: isExpanded ?? this.isExpanded,
      seriesData: seriesData ?? this.seriesData,
      seriesLabels: seriesLabels ?? this.seriesLabels,
      currentValue: currentValue ?? this.currentValue,
      previousValue: previousValue ?? this.previousValue,
      unit: unit ?? this.unit,
      legendLabels: legendLabels ?? this.legendLabels,
      pieData: pieData ?? this.pieData,
    );
  }

  static List<DashboardCardModel> get defaults => [
    DashboardCardModel(
      id: 'revenue',
      title: 'Revenue',
      subtitle: 'Monthly overview',
      type: CardType.area,
      accentColor: FluxColors.primary,
      icon: Icons.trending_up_rounded,
      gridPosition: 0,
      seriesData: [42, 58, 51, 67, 73, 88, 79, 94, 102, 89, 115, 128],
      seriesLabels: ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'],
      currentValue: 128400,
      previousValue: 115200,
      unit: '\$',
    ),
    DashboardCardModel(
      id: 'users',
      title: 'Active Users',
      subtitle: 'Last 7 days',
      type: CardType.bar,
      accentColor: FluxColors.secondary,
      icon: Icons.people_alt_rounded,
      gridPosition: 1,
      seriesData: [1200, 1850, 1420, 2100, 1780, 2340, 2890],
      seriesLabels: ['Mon','Tue','Wed','Thu','Fri','Sat','Sun'],
      currentValue: 24783,
      previousValue: 22100,
      unit: '',
    ),
    DashboardCardModel(
      id: 'traffic',
      title: 'Traffic Sources',
      subtitle: 'Distribution',
      type: CardType.pie,
      accentColor: FluxColors.accent,
      icon: Icons.donut_large_rounded,
      gridPosition: 2,
      seriesData: [],
      seriesLabels: [],
      currentValue: 0,
      previousValue: 0,
      pieData: [38.5, 27.2, 19.8, 14.5],
      legendLabels: ['Organic', 'Direct', 'Social', 'Referral'],
    ),
    DashboardCardModel(
      id: 'conversion',
      title: 'Conversion Rate',
      subtitle: 'This month',
      type: CardType.line,
      accentColor: FluxColors.warning,
      icon: Icons.show_chart_rounded,
      gridPosition: 3,
      seriesData: [3.2, 3.8, 2.9, 4.1, 3.7, 4.8, 4.2, 5.1, 4.9, 5.6, 5.2, 6.1],
      seriesLabels: ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'],
      currentValue: 6.1,
      previousValue: 5.2,
      unit: '%',
    ),
    DashboardCardModel(
      id: 'orders',
      title: 'Orders',
      subtitle: 'Today',
      type: CardType.stat,
      accentColor: FluxColors.danger,
      icon: Icons.shopping_bag_outlined,
      gridPosition: 4,
      seriesData: [44, 52, 38, 61, 49, 73, 58],
      seriesLabels: ['Mon','Tue','Wed','Thu','Fri','Sat','Sun'],
      currentValue: 847,
      previousValue: 792,
      unit: '',
    ),
    DashboardCardModel(
      id: 'performance',
      title: 'Server Perf',
      subtitle: 'Response time (ms)',
      type: CardType.line,
      accentColor: FluxColors.accent,
      icon: Icons.speed_outlined,
      gridPosition: 5,
      seriesData: [120, 95, 110, 88, 102, 78, 92, 85, 74, 81, 70, 68],
      seriesLabels: ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'],
      currentValue: 68,
      previousValue: 120,
      unit: 'ms',
    ),
  ];
}
