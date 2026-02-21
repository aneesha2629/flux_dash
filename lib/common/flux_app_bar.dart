import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/app_colors.dart';
import '../../state/dashboard_provider.dart';

class FluxAppBar extends StatelessWidget implements PreferredSizeWidget {
  final LayoutType layout;
  final VoidCallback onLayoutToggle;
  final VoidCallback onRefresh;
  final VoidCallback onSettings;
  final bool isLive;

  const FluxAppBar({
    super.key,
    required this.layout,
    required this.onLayoutToggle,
    required this.onRefresh,
    required this.onSettings,
    this.isLive = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: const BoxDecoration(
          color: FluxColors.bg00,
          border: Border(bottom: BorderSide(color: FluxColors.bg04, width: 1)),
        ),
        child: Row(
          children: [
            // Logo icon
            Container(
              width: 30, height: 30,
              decoration: BoxDecoration(
                gradient: FluxColors.primaryGradient,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.bolt, color: FluxColors.bg01, size: 16),
            ),
            const SizedBox(width: 8),

            // FLUXDASH text
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'FLUX',
                    style: GoogleFonts.orbitron(
                      color: FluxColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                    ),
                  ),
                  TextSpan(
                    text: 'DASH',
                    style: GoogleFonts.orbitron(
                      color: FluxColors.primary,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // Live badge
            if (isLive) _LiveBadge(),

            const Spacer(),

            // Icons - compact
            _IconBtn(
              icon: layout == LayoutType.grid
                  ? Icons.view_list_rounded
                  : Icons.grid_view_rounded,
              onTap: onLayoutToggle,
            ),
            const SizedBox(width: 6),
            _IconBtn(icon: Icons.refresh_rounded, onTap: onRefresh),
            const SizedBox(width: 6),
            _IconBtn(icon: Icons.tune_rounded, onTap: onSettings),
          ],
        ),
      ),
    );
  }
}

class _LiveBadge extends StatefulWidget {
  @override
  State<_LiveBadge> createState() => _LiveBadgeState();
}

class _LiveBadgeState extends State<_LiveBadge>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 1))
      ..repeat(reverse: true);
    _anim = Tween<double>(begin: 0.4, end: 1.0).animate(_ctrl);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
        decoration: BoxDecoration(
          color: FluxColors.success.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: FluxColors.success.withOpacity(_anim.value * 0.6)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 5, height: 5,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: FluxColors.success.withOpacity(_anim.value),
              ),
            ),
            const SizedBox(width: 4),
            Text(
              'LIVE',
              style: GoogleFonts.jetBrainsMono(
                color: FluxColors.success,
                fontSize: 9,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _IconBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 34, height: 34,
        decoration: BoxDecoration(
          color: FluxColors.bg03,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: FluxColors.bg04),
        ),
        child: Icon(icon, color: FluxColors.textSecondary, size: 16),
      ),
    );
  }
}
