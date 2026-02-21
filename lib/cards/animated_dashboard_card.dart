import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/app_colors.dart';
import '../../../core/app_constants.dart';
import '../../../data/dashboard_card_model.dart';
import '../charts/animated_line_chart.dart';
import '../charts/animated_bar_chart.dart';
import '../charts/animated_pie_chart.dart';
import '../common/animated_counter.dart';

class AnimatedDashboardCard extends StatefulWidget {
  final DashboardCardModel card;
  final VoidCallback onTap;
  final VoidCallback? onDelete;
  final bool isDragging;

  const AnimatedDashboardCard({
    super.key,
    required this.card,
    required this.onTap,
    this.onDelete,
    this.isDragging = false,
  });

  @override
  State<AnimatedDashboardCard> createState() => _AnimatedDashboardCardState();
}

class _AnimatedDashboardCardState extends State<AnimatedDashboardCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _glowController;
  late Animation<double> _glowAnim;
  double _swipeDx = 0;
  bool _isSwiping = false;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _glowAnim = Tween<double>(begin: 0.3, end: 0.8).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  void _onHorizontalDragUpdate(DragUpdateDetails d) {
    setState(() { _swipeDx += d.delta.dx; _isSwiping = true; });
  }

  void _onHorizontalDragEnd(DragEndDetails _) {
    if (_swipeDx < -120 && widget.onDelete != null) {
      widget.onDelete!();
    } else {
      setState(() { _swipeDx = 0; _isSwiping = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onHorizontalDragUpdate: _onHorizontalDragUpdate,
      onHorizontalDragEnd: _onHorizontalDragEnd,
      child: Stack(
        children: [
          // Delete background
          if (_isSwiping && _swipeDx < -20)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: FluxColors.danger.withOpacity(
                    ((-_swipeDx - 20) / 120).clamp(0.0, 1.0) * 0.25),
                  borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
                ),
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 16),
                child: Icon(Icons.delete_outline_rounded,
                  color: FluxColors.danger.withOpacity(
                    ((-_swipeDx - 20) / 100).clamp(0.0, 1.0)),
                  size: 24),
              ),
            ),

          // Card
          AnimatedBuilder(
            animation: _glowAnim,
            builder: (context, child) => Transform.translate(
              offset: Offset(_swipeDx.clamp(-160.0, 0.0), 0),
              child: AnimatedContainer(
                duration: _isSwiping
                    ? Duration.zero
                    : const Duration(milliseconds: AppConstants.animNormal),
                curve: Curves.easeOutCubic,
                decoration: BoxDecoration(
                  color: FluxColors.bg02,
                  borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
                  border: Border.all(
                    color: widget.isDragging
                        ? widget.card.accentColor
                        : widget.card.isExpanded
                            ? widget.card.accentColor.withOpacity(0.5)
                            : FluxColors.bg04,
                    width: widget.isDragging ? 2 : 1,
                  ),
                  boxShadow: [
                    if (widget.isDragging)
                      BoxShadow(
                        color: widget.card.accentColor.withOpacity(0.3),
                        blurRadius: 20, spreadRadius: 2),
                    if (widget.card.isExpanded)
                      BoxShadow(
                        color: widget.card.accentColor
                            .withOpacity(_glowAnim.value * 0.15),
                        blurRadius: 16),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 8, offset: const Offset(0, 3)),
                  ],
                ),
                child: child,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
              child: Column(
                mainAxisSize: MainAxisSize.min,   // ← KEY FIX: min size
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTopAccent(),
                  Padding(
                    padding: const EdgeInsets.all(12), // reduced from 16
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(),
                        if (widget.card.type != CardType.pie) ...[
                          const SizedBox(height: 8),
                          _buildValueRow(),
                        ],
                        const SizedBox(height: 10),
                        _buildChart(),
                        if (widget.card.isExpanded) ...[
                          const SizedBox(height: 12),
                          _buildExpandedStats(),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopAccent() {
    return Container(
      height: widget.card.isExpanded ? 3 : 2,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [widget.card.accentColor, widget.card.accentColor.withOpacity(0.0)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final card = widget.card;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Hero(
          tag: 'card_icon_${card.id}',
          child: Container(
            width: 32, height: 32,
            decoration: BoxDecoration(
              color: card.accentColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(9),
              border: Border.all(color: card.accentColor.withOpacity(0.2)),
            ),
            child: Icon(card.icon, color: card.accentColor, size: 16),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: 'card_title_${card.id}',
                child: Material(
                  color: Colors.transparent,
                  child: Text(
                    card.title,
                    style: GoogleFonts.spaceGrotesk(
                      color: FluxColors.textPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              Text(
                card.subtitle,
                style: GoogleFonts.spaceGrotesk(
                  color: FluxColors.textMuted, fontSize: 10),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () => _showCardMenu(card),
          child: Container(
            padding: const EdgeInsets.all(4),
            child: const Icon(Icons.more_horiz,
                color: FluxColors.textMuted, size: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildValueRow() {
    final card = widget.card;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
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
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        const Spacer(),
        TrendBadge(percent: card.trendPercent),
      ],
    );
  }

  Widget _buildChart() {
    final card = widget.card;
    // Fixed heights — no overflow
    double height;
    if (card.type == CardType.pie) {
      height = card.isExpanded ? 180.0 : 130.0;
    } else {
      height = card.isExpanded ? 140.0 : 80.0;
    }

    return SizedBox(
      height: height,
      child: RepaintBoundary(child: _chartByType(card)),
    );
  }

  Widget _chartByType(DashboardCardModel card) {
    switch (card.type) {
      case CardType.line:
        return AnimatedLineChart(
            data: card.seriesData, labels: card.seriesLabels, color: card.accentColor);
      case CardType.area:
        return AnimatedLineChart(
            data: card.seriesData, labels: card.seriesLabels,
            color: card.accentColor, isArea: true);
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

  Widget _buildExpandedStats() {
    final card = widget.card;
    if (card.seriesData.isEmpty) return const SizedBox.shrink();
    final peak = card.seriesData.reduce((a, b) => a > b ? a : b);
    final low  = card.seriesData.reduce((a, b) => a < b ? a : b);
    final avg  = card.seriesData.fold(0.0, (a, b) => a + b) / card.seriesData.length;

    return Column(
      children: [
        Container(height: 1, color: FluxColors.bg04,
            margin: const EdgeInsets.only(bottom: 10)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _statItem('Peak', '${peak.toStringAsFixed(1)}${card.unit}', card.accentColor),
            _statItem('Low',  '${low.toStringAsFixed(1)}${card.unit}',  FluxColors.danger),
            _statItem('Avg',  '${avg.toStringAsFixed(1)}${card.unit}',  FluxColors.textSecondary),
          ],
        ),
      ],
    );
  }

  Widget _statItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(value,
            style: GoogleFonts.orbitron(
                color: color, fontSize: 12, fontWeight: FontWeight.w700)),
        Text(label,
            style: const TextStyle(color: FluxColors.textMuted, fontSize: 10)),
      ],
    );
  }

  void _showCardMenu(DashboardCardModel card) {
    showModalBottomSheet(
      context: context,
      backgroundColor: FluxColors.bg02,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => _CardMenuSheet(card: card, onDelete: widget.onDelete),
    );
  }
}

// ── Bottom Sheet Menu ─────────────────────────────────────────────
class _CardMenuSheet extends StatelessWidget {
  final DashboardCardModel card;
  final VoidCallback? onDelete;
  const _CardMenuSheet({required this.card, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 40, height: 4,
              decoration: BoxDecoration(
                  color: FluxColors.bg04, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 16),
          Row(children: [
            Icon(card.icon, color: card.accentColor),
            const SizedBox(width: 10),
            Text(card.title, style: const TextStyle(
                color: FluxColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 16)),
          ]),
          const SizedBox(height: 16),
          _MenuItem(icon: Icons.open_in_full_rounded, label: 'Expand Card',
              onTap: () => Navigator.pop(context)),
          _MenuItem(icon: Icons.refresh_rounded, label: 'Refresh Data',
              onTap: () => Navigator.pop(context)),
          if (onDelete != null)
            _MenuItem(icon: Icons.delete_outline_rounded, label: 'Remove Card',
                isDestructive: true,
                onTap: () { Navigator.pop(context); onDelete!(); }),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;
  const _MenuItem({required this.icon, required this.label,
      required this.onTap, this.isDestructive = false});

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? FluxColors.danger : FluxColors.textSecondary;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Row(children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 14),
          Text(label, style: TextStyle(color: color, fontSize: 14)),
        ]),
      ),
    );
  }
}
