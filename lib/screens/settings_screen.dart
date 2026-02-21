import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/app_colors.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FluxColors.bg00,
      appBar: AppBar(
        backgroundColor: FluxColors.bg00,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: FluxColors.textSecondary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Settings',
          style: GoogleFonts.orbitron(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: FluxColors.textPrimary,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: FluxColors.bg04),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SectionLabel('APPEARANCE'),
          _SettingsTile(
            icon: Icons.dark_mode_rounded,
            title: 'Dark Mode',
            subtitle: 'Always enabled',
            trailing: const Icon(Icons.check_circle_rounded, color: FluxColors.primary, size: 20),
          ),
          _SettingsTile(
            icon: Icons.color_lens_rounded,
            title: 'Accent Color',
            subtitle: 'Cyan (default)',
            trailing: Container(
              width: 20, height: 20,
              decoration: BoxDecoration(
                color: FluxColors.primary,
                shape: BoxShape.circle,
              ),
            ),
          ),

          const SizedBox(height: 16),
          _SectionLabel('DATA'),
          _SettingsTile(
            icon: Icons.timer_rounded,
            title: 'Refresh Interval',
            subtitle: 'Every 3 seconds',
            trailing: const Icon(Icons.chevron_right_rounded, color: FluxColors.textMuted),
          ),
          _SettingsTile(
            icon: Icons.storage_rounded,
            title: 'Clear Saved Layout',
            subtitle: 'Reset card positions',
            trailing: const Icon(Icons.chevron_right_rounded, color: FluxColors.textMuted),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Layout cleared', style: GoogleFonts.spaceGrotesk()),
                  backgroundColor: FluxColors.bg03,
                ),
              );
            },
          ),

          const SizedBox(height: 16),
          _SectionLabel('ABOUT'),
          _SettingsTile(
            icon: Icons.info_outline_rounded,
            title: 'FluxDash',
            subtitle: 'v1.0.0 — Professional Analytics Dashboard',
            trailing: const Icon(Icons.chevron_right_rounded, color: FluxColors.textMuted),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Text(
        text,
        style: GoogleFonts.jetBrainsMono(
          color: FluxColors.textMuted,
          fontSize: 10,
          letterSpacing: 2,
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: FluxColors.bg02,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: FluxColors.bg04),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          width: 36, height: 36,
          decoration: BoxDecoration(
            color: FluxColors.bg03,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: FluxColors.textSecondary, size: 18),
        ),
        title: Text(
          title,
          style: GoogleFonts.spaceGrotesk(
            color: FluxColors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.spaceGrotesk(
            color: FluxColors.textMuted,
            fontSize: 12,
          ),
        ),
        trailing: trailing,
      ),
    );
  }
}
