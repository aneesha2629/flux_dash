import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class DashboardCard extends StatefulWidget {
  final String title;
  final Widget chart;

  const DashboardCard({super.key, required this.title, required this.chart});

  @override
  State<DashboardCard> createState() => _DashboardCardState();
}

class _DashboardCardState extends State<DashboardCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => isExpanded = !isExpanded),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.title, 
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
            ),
            const SizedBox(height: 10),
            Expanded(child: widget.chart),
            
            if (isExpanded) 
              Padding( 
                padding: const EdgeInsets.only(top: 10), 
                child: const Text("Detailed analytics and insights go here..."),
              ).animate().fadeIn(), 
          ],
        ),
      ),
    );
  }
}