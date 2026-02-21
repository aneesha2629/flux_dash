import 'package:flutter/material.dart';
import '../../../data/dashboard_card_model.dart';
import '../cards/animated_dashboard_card.dart';

class DashboardList extends StatelessWidget {
  final List<DashboardCardModel> cards;
  final Function(String cardId) onCardTap;
  final Function(int from, int to) onReorder;
  final Function(String cardId) onDelete;

  const DashboardList({
    super.key,
    required this.cards,
    required this.onCardTap,
    required this.onReorder,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ReorderableListView.builder(
      padding: const EdgeInsets.all(12),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      onReorder: onReorder,
      proxyDecorator: (child, index, animation) {
        return AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            return Material(
              color: Colors.transparent,
              elevation: 8 * animation.value,
              shadowColor: cards[index].accentColor.withOpacity(0.3),
              borderRadius: BorderRadius.circular(16),
              child: child,
            );
          },
          child: child,
        );
      },
      itemCount: cards.length,
      itemBuilder: (context, index) {
        final card = cards[index];
        return Padding(
          key: ValueKey(card.id),
          padding: const EdgeInsets.only(bottom: 10),
          child: Dismissible(
            key: ValueKey('dismiss_${card.id}'),
            direction: DismissDirection.endToStart,
            background: _buildDismissBackground(),
            onDismissed: (_) => onDelete(card.id),
            child: AnimatedDashboardCard(
              card: card,
              onTap: () => onCardTap(card.id),
              onDelete: () => onDelete(card.id),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDismissBackground() {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFFF4D6D).withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFF4D6D).withOpacity(0.4)),
      ),
      child: const Icon(
        Icons.delete_outline_rounded,
        color: Color(0xFFFF4D6D),
        size: 28,
      ),
    );
  }
}
