import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import '../state/dashboard_provider.dart';
import '../common/flux_app_bar.dart';
import '../common/loading_shimmer.dart';
import '../common/summary_stats_bar.dart';
import '../layout/dashboard_grid.dart';
import '../layout/dashboard_list.dart';
import '../cards/swipeable_card.dart';
import 'card_detail_screen.dart';
import 'settings_screen.dart';
import '../../core/app_colors.dart';
import '../../data/dashboard_card_model.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _navigateToDetail(BuildContext context, DashboardCardModel card) {
    // MaterialPageRoute → Hero animations work automatically
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CardDetailScreen(card: card)),
    );
  }

  void _navigateToSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SettingsScreen()),
    );
  }

  DashboardCardModel? _findCard(DashboardProvider provider, String id) {
    try {
      return provider.cards.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          backgroundColor: FluxColors.bg01,
          appBar: FluxAppBar(
            layout: provider.layout,
            onLayoutToggle: provider.toggleLayout,
            onRefresh: provider.refreshNow,
            onSettings: () => _navigateToSettings(context),
          ),
          body: provider.isLoading
              ? _buildLoading()
              : _buildBody(context, provider),
          floatingActionButton: _buildFAB(context, provider),
        );
      },
    );
  }

  Widget _buildLoading() {
    return GridView.count(
      crossAxisCount: 2,
      padding: const EdgeInsets.all(12),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      children: List.generate(6, (_) => const FluxShimmerCard()),
    );
  }

  Widget _buildBody(BuildContext context, DashboardProvider provider) {
    return CustomScrollView(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      slivers: [
   
        SliverToBoxAdapter(
          child: FadeInDown(
            duration: const Duration(milliseconds: 400),
            child: const SummaryStatsBar(),
          ),
        ),

        if (provider.cards.length >= 3)
          SliverToBoxAdapter(
            child: FadeInUp(
              delay: const Duration(milliseconds: 100),
              duration: const Duration(milliseconds: 400),
              child: Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      child: Row(
                        children: [
                          Text(
                            'HIGHLIGHTS',
                            style: GoogleFonts.jetBrainsMono(
                              color: FluxColors.textMuted,
                              fontSize: 10,
                              letterSpacing: 2,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            'Swipe to explore',
                            style: GoogleFonts.spaceGrotesk(
                              color: FluxColors.textMuted,
                              fontSize: 11,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.swipe,   // ← fixed icon name
                            color: FluxColors.textMuted,
                            size: 14,
                          ),
                        ],
                      ),
                    ),
                    SwipeableCardStack(
                      cards: provider.cards.take(3).toList(),
                      onCardTap: (id) {
                        final card = _findCard(provider, id);
                        if (card != null) _navigateToDetail(context, card);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),

        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
            child: Row(
              children: [
                Text(
                  'ALL METRICS',
                  style: GoogleFonts.jetBrainsMono(
                    color: FluxColors.textMuted,
                    fontSize: 10,
                    letterSpacing: 2,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: FluxColors.bg03,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: FluxColors.bg04),
                  ),
                  child: Text(
                    '${provider.cards.length} cards',
                    style: const TextStyle(color: FluxColors.textMuted, fontSize: 10),
                  ),
                ),
              ],
            ),
          ),
        ),

 
        SliverToBoxAdapter(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),
            switchInCurve: Curves.easeOutCubic,
            child: provider.layout == LayoutType.grid
                ? DashboardGrid(
                    key: const ValueKey('grid'),
                    cards: provider.cards,
                    onCardTap: (id) {
                      final card = _findCard(provider, id);
                      if (card == null) return;
                      provider.toggleExpand(id);
                     
                      if (card.isExpanded) _navigateToDetail(context, card);
                    },
                    onReorder: provider.reorderCards,
                    onDelete: provider.removeCard,
                  )
                : DashboardList(
                    key: const ValueKey('list'),
                    cards: provider.cards,
                    onCardTap: (id) {
                      final card = _findCard(provider, id);
                      if (card == null) return;
                      provider.toggleExpand(id);
                     
                      if (card.isExpanded) _navigateToDetail(context, card);
                    },
                    onReorder: provider.reorderCards,
                    onDelete: provider.removeCard,
                  ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }

  Widget _buildFAB(BuildContext context, DashboardProvider provider) {
    return FloatingActionButton.extended(
      onPressed: provider.refreshNow,
      backgroundColor: FluxColors.primary,
      foregroundColor: FluxColors.bg01,
      icon: const Icon(Icons.refresh_rounded, size: 20),
      label: Text(
        'Refresh',
        style: GoogleFonts.spaceGrotesk(
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
      elevation: 12,
    );
  }
}
