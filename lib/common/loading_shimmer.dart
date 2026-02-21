import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/app_colors.dart';

class FluxShimmerCard extends StatelessWidget {
  const FluxShimmerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: FluxColors.bg03,
      highlightColor: FluxColors.bg04,
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          color: FluxColors.bg02,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(
                    color: FluxColors.bg04,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(width: 100, height: 12, color: FluxColors.bg04),
                    const SizedBox(height: 6),
                    Container(width: 70, height: 10, color: FluxColors.bg04),
                  ],
                ),
              ],
            ),
            const Spacer(),
            Container(width: 80, height: 28, color: FluxColors.bg04),
            const SizedBox(height: 16),
            Container(
              height: 60,
              decoration: BoxDecoration(
                color: FluxColors.bg04,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
