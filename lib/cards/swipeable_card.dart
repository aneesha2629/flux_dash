import 'package:flutter/material.dart';
import '../../../data/dashboard_card_model.dart';
import 'animated_dashboard_card.dart';
import '../../../core/app_colors.dart';

class SwipeableCardStack extends StatefulWidget {
  final List<DashboardCardModel> cards;
  final Function(String cardId) onCardTap;

  const SwipeableCardStack({
    super.key,
    required this.cards,
    required this.onCardTap,
  });

  @override
  State<SwipeableCardStack> createState() => _SwipeableCardStackState();
}

class _SwipeableCardStackState extends State<SwipeableCardStack>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.88);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 240,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.cards.length,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemBuilder: (context, index) {
              final isActive = index == _currentPage;
              return AnimatedScale(
                scale: isActive ? 1.0 : 0.93,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                  child: AnimatedDashboardCard(
                    card: widget.cards[index],
                    onTap: () => widget.onCardTap(widget.cards[index].id),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        _PageIndicator(
          count: widget.cards.length,
          currentIndex: _currentPage,
          accentColor: widget.cards.isNotEmpty
              ? widget.cards[_currentPage].accentColor
              : FluxColors.primary,
        ),
      ],
    );
  }
}

class _PageIndicator extends StatelessWidget {
  final int count;
  final int currentIndex;
  final Color accentColor;

  const _PageIndicator({
    required this.count,
    required this.currentIndex,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final isActive = i == currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: isActive ? 20 : 6,
          height: 6,
          decoration: BoxDecoration(
            color: isActive ? accentColor : FluxColors.bg04,
            borderRadius: BorderRadius.circular(3),
          ),
        );
      }),
    );
  }
}
