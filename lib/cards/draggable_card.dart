import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../data/dashboard_card_model.dart';
import 'animated_dashboard_card.dart';

class DraggableCard extends StatefulWidget {
  final DashboardCardModel card;
  final int index;
  final VoidCallback onTap;
  final Function(int fromIndex) onDragStarted;
  final Function(int toIndex) onDragAccepted;
  final VoidCallback? onDelete;

  const DraggableCard({
    super.key,
    required this.card,
    required this.index,
    required this.onTap,
    required this.onDragStarted,
    required this.onDragAccepted,
    this.onDelete,
  });

  @override
  State<DraggableCard> createState() => _DraggableCardState();
}

class _DraggableCardState extends State<DraggableCard> {
  bool _isDragging = false;
  bool _isTargeted = false;

  @override
  Widget build(BuildContext context) {
    return DragTarget<int>(
      onWillAcceptWithDetails: (details) {
        setState(() => _isTargeted = details.data != widget.index);
        return details.data != widget.index;
      },
      onLeave: (_) => setState(() => _isTargeted = false),
      onAcceptWithDetails: (details) {
        setState(() => _isTargeted = false);
        widget.onDragAccepted(widget.index);
      },
      builder: (context, candidateData, rejectedData) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: _isTargeted
                ? Border.all(
                    color: widget.card.accentColor.withOpacity(0.6),
                    width: 2,
                  )
                : null,
          ),
          child: LongPressDraggable<int>(
            data: widget.index,
            delay: const Duration(milliseconds: 300),
            onDragStarted: () {
              HapticFeedback.mediumImpact();
              setState(() => _isDragging = true);
              widget.onDragStarted(widget.index);
            },
            onDragEnd: (_) => setState(() => _isDragging = false),
            onDraggableCanceled: (_, __) => setState(() => _isDragging = false),
            feedback: Material(
              color: Colors.transparent,
              child: Transform.scale(
                scale: 1.05,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: Opacity(
                    opacity: 0.9,
                    child: AnimatedDashboardCard(
                      card: widget.card,
                      onTap: () {},
                      isDragging: true,
                    ),
                  ),
                ),
              ),
            ),
            childWhenDragging: Opacity(
              opacity: 0.3,
              child: AnimatedDashboardCard(
                card: widget.card,
                onTap: () {},
              ),
            ),
            child: AnimatedDashboardCard(
              card: widget.card,
              onTap: widget.onTap,
              onDelete: widget.onDelete,
              isDragging: _isDragging,
            ),
          ),
        );
      },
    );
  }
}
