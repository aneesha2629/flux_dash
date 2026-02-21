import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../../data/dashboard_card_model.dart';
import '../cards/draggable_card.dart';

class DashboardGrid extends StatefulWidget {
  final List<DashboardCardModel> cards;
  final Function(String cardId) onCardTap;
  final Function(int from, int to) onReorder;
  final Function(String cardId) onDelete;

  const DashboardGrid({
    super.key,
    required this.cards,
    required this.onCardTap,
    required this.onReorder,
    required this.onDelete,
  });

  @override
  State<DashboardGrid> createState() => _DashboardGridState();
}

class _DashboardGridState extends State<DashboardGrid> {
  int? _draggingFromIndex;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: MasonryGridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: widget.cards.length,
        itemBuilder: (context, index) {
          final card = widget.cards[index];
          return DraggableCard(
            key: ValueKey(card.id),
            card: card,
            index: index,
            onTap: () => widget.onCardTap(card.id),
            onDragStarted: (fromIndex) => _draggingFromIndex = fromIndex,
            onDragAccepted: (toIndex) {
              if (_draggingFromIndex != null) {
                widget.onReorder(_draggingFromIndex!, toIndex);
                _draggingFromIndex = null;
              }
            },
            onDelete: () => widget.onDelete(card.id),
          );
        },
      ),
    );
  }
}
