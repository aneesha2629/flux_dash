import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/app_colors.dart';

class AnimatedCounter extends StatelessWidget {
  final double value;
  final String unit;
  final TextStyle? style;
  final bool compact;

  const AnimatedCounter({
    super.key,
    required this.value,
    required this.unit,
    this.style,
    this.compact = false,
  });

  String _format(double v) {
    if (compact) {
      if (v >= 1000000) return '${(v / 1000000).toStringAsFixed(1)}M';
      if (v >= 1000) return '${(v / 1000).toStringAsFixed(1)}K';
    }
    if (unit == '%') return v.toStringAsFixed(1);
    if (unit == 'ms') return v.toStringAsFixed(0);
    if (unit == '\$') return NumberFormat.compact().format(v);
    return NumberFormat.compact().format(v);
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: value * 0.7, end: value),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutCubic,
      builder: (context, animatedValue, _) {
        return RichText(
          text: TextSpan(
            children: [
              if (unit == '\$')
                TextSpan(
                  text: '\$',
                  style: (style ?? const TextStyle()).copyWith(
                    color: FluxColors.textMuted,
                    fontSize: (style?.fontSize ?? 24) * 0.6,
                  ),
                ),
              TextSpan(
                text: _format(animatedValue),
                style: style,
              ),
              if (unit != '\$' && unit.isNotEmpty)
                TextSpan(
                  text: unit,
                  style: (style ?? const TextStyle()).copyWith(
                    color: FluxColors.textMuted,
                    fontSize: (style?.fontSize ?? 24) * 0.55,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class TrendBadge extends StatelessWidget {
  final double percent;

  const TrendBadge({super.key, required this.percent});

  @override
  Widget build(BuildContext context) {
    final isUp = percent >= 0;
    final color = isUp ? FluxColors.success : FluxColors.danger;
    final icon = isUp ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: color),
          const SizedBox(width: 2),
          Text(
            '${percent.abs().toStringAsFixed(1)}%',
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
