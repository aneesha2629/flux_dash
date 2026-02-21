import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/dashboard_card_model.dart';
import '../charts/animated_line_chart.dart';
import '../charts/animated_bar_chart.dart';
import '../charts/animated_pie_chart.dart';
import '../common/animated_counter.dart';
import '../../core/app_colors.dart';

class CardDetailScreen extends StatelessWidget {
  final DashboardCardModel card;
  const CardDetailScreen({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FluxColors.bg00,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          SliverToBoxAdapter(child: _buildContent(context)),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 140,
      pinned: true,
      backgroundColor: FluxColors.bg00,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_rounded, color: FluxColors.textSecondary),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
     
        title: Hero(
          tag: 'card_title_${card.id}',
          child: Material(
            color: Colors.transparent,
            child: Text(
              card.title,
              style: GoogleFonts.orbitron(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: FluxColors.textPrimary,
              ),
            ),
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [card.accentColor.withOpacity(0.2), FluxColors.bg00],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
      
          child: Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 48, right: 20),
              child: Hero(
                tag: 'card_icon_${card.id}',
                child: Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: card.accentColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: card.accentColor.withOpacity(0.3)),
                  ),
                  child: Icon(card.icon, color: card.accentColor, size: 26),
                ),
              ),
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.share_rounded, color: FluxColors.textSecondary),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (card.type != CardType.pie) _buildValueHero(),
          const SizedBox(height: 24),
          _buildFullChart(),
          const SizedBox(height: 24),
          if (card.seriesData.isNotEmpty) _buildStatsGrid(),
          const SizedBox(height: 24),
          if (card.seriesData.isNotEmpty) _buildDataTable(),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildValueHero() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [card.accentColor.withOpacity(0.08), FluxColors.bg02],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: card.accentColor.withOpacity(0.2)),
      ),
      child: Row(
        children: [
       
          Hero(
            tag: 'card_value_${card.id}',
            child: Material(
              color: Colors.transparent,
              child: AnimatedCounter(
                value: card.currentValue,
                unit: card.unit,
                style: GoogleFonts.orbitron(
                  color: FluxColors.textPrimary,
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          const Spacer(),
          TrendBadge(percent: card.trendPercent),
        ],
      ),
    );
  }

  Widget _buildFullChart() {
    return Container(
      padding: const EdgeInsets.all(16),
      height: 280,
      decoration: BoxDecoration(
        color: FluxColors.bg02,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: FluxColors.bg04),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('TREND',
              style: GoogleFonts.jetBrainsMono(
                color: FluxColors.textMuted,
                fontSize: 10,
                letterSpacing: 2,
              )),
          const SizedBox(height: 12),
          Expanded(child: RepaintBoundary(child: _chartByType())),
        ],
      ),
    );
  }

  Widget _chartByType() {
    switch (card.type) {
      case CardType.line:
        return AnimatedLineChart(
            data: card.seriesData, labels: card.seriesLabels, color: card.accentColor);
      case CardType.area:
        return AnimatedLineChart(
            data: card.seriesData,
            labels: card.seriesLabels,
            color: card.accentColor,
            isArea: true);
      case CardType.bar:
        return AnimatedBarChart(
            data: card.seriesData, labels: card.seriesLabels, color: card.accentColor);
      case CardType.pie:
        return AnimatedPieChart(data: card.pieData, labels: card.legendLabels);
      case CardType.stat:
        return AnimatedBarChart(
            data: card.seriesData, labels: card.seriesLabels, color: card.accentColor);
    }
  }

  Widget _buildStatsGrid() {
    final peak = card.seriesData.reduce((a, b) => a > b ? a : b);
    final low  = card.seriesData.reduce((a, b) => a < b ? a : b);
    final avg  = card.seriesData.fold(0.0, (a, b) => a + b) / card.seriesData.length;
    final total = card.seriesData.fold(0.0, (a, b) => a + b);

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 2.2,
      children: [
        _StatCard(label: 'Peak',    value: peak.toStringAsFixed(1),  unit: card.unit, color: FluxColors.success),
        _StatCard(label: 'Low',     value: low.toStringAsFixed(1),   unit: card.unit, color: FluxColors.danger),
        _StatCard(label: 'Average', value: avg.toStringAsFixed(1),   unit: card.unit, color: FluxColors.primary),
        _StatCard(label: 'Total',   value: total.toStringAsFixed(0), unit: card.unit, color: FluxColors.secondary),
      ],
    );
  }

  Widget _buildDataTable() {
    return Container(
      decoration: BoxDecoration(
        color: FluxColors.bg02,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: FluxColors.bg04),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text('DATA TABLE',
                style: GoogleFonts.jetBrainsMono(
                    color: FluxColors.textMuted, fontSize: 10, letterSpacing: 2)),
          ),
          const Divider(color: FluxColors.bg04, height: 1),
          ...card.seriesData.asMap().entries.map((entry) {
            final isLast = entry.key == card.seriesData.length - 1;
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Row(
                    children: [
                      Text(
                        card.seriesLabels.length > entry.key
                            ? card.seriesLabels[entry.key]
                            : 'Point ${entry.key + 1}',
                        style: const TextStyle(
                            color: FluxColors.textSecondary, fontSize: 13),
                      ),
                      const Spacer(),
                      Text(
                        '${entry.value.toStringAsFixed(2)}${card.unit}',
                        style: TextStyle(
                          color: card.accentColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                if (!isLast) const Divider(color: FluxColors.bg04, height: 1),
              ],
            );
          }),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label, value, unit;
  final Color color;
  const _StatCard({required this.label, required this.value, required this.unit, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: FluxColors.bg02,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: FluxColors.bg04),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, style: const TextStyle(color: FluxColors.textMuted, fontSize: 11)),
          const SizedBox(height: 4),
          Text('$value$unit',
              style: GoogleFonts.orbitron(
                  color: color, fontSize: 16, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
