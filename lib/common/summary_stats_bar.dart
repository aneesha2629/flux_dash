import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/app_colors.dart';

class SummaryStatsBar extends StatelessWidget {
  const SummaryStatsBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0C1120), Color(0xFF111827)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: FluxColors.bg04),
      ),
      child: Row(
        children: const [
          _SummaryStat(
            label: 'Total Revenue',
            value: '\$1.28M',
            change: '+11.3%',
            positive: true,
          ),
          _Divider(),
          _SummaryStat(
            label: 'Active Users',
            value: '24.7K',
            change: '+12.1%',
            positive: true,
          ),
          _Divider(),
          _SummaryStat(
            label: 'Avg. Response',
            value: '68ms',
            change: '-43.3%',
            positive: true,
          ),
        ],
      ),
    );
  }
}

class _SummaryStat extends StatelessWidget {
  final String label;
  final String value;
  final String change;
  final bool positive;

  const _SummaryStat({
    required this.label,
    required this.value,
    required this.change,
    required this.positive,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            value,
            style: GoogleFonts.orbitron(
              color: FluxColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              color: FluxColors.textMuted,
              fontSize: 10,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: (positive ? FluxColors.success : FluxColors.danger)
                  .withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              change,
              style: TextStyle(
                color: positive ? FluxColors.success : FluxColors.danger,
                fontSize: 9,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1, height: 40,
      color: FluxColors.bg04,
      margin: const EdgeInsets.symmetric(horizontal: 8),
    );
  }
}
