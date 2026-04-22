import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../ticket/presentation/providers/ticket_provider.dart';
import '../providers/theme_provider.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authNotifierProvider).user;
    final themeMode = ref.watch(themeNotifierProvider);
    final ticketState = ref.watch(ticketListNotifierProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final totalTickets = ticketState.tickets.length;
    final completedTickets = ticketState.tickets.where((t) => t.status == 'selesai').length;
    final pendingTickets = ticketState.tickets.where((t) => t.status == 'pending').length;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ─── Top Row ──────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Profil',
                    style: GoogleFonts.outfit(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : AppColors.textPrimary,
                      letterSpacing: -0.5,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.surfaceElevatedDark : AppColors.surfaceElevatedLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.settings_outlined,
                      size: 20,
                      color: isDark ? Colors.white : AppColors.textPrimary,
                    ),
                  ),
                ],
              ).animate().fadeIn(),

              const SizedBox(height: 28),

              // ─── User Card (horizontal layout) ────
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withOpacity(0.15)),
                      ),
                      child: Center(
                        child: Text(
                          user?.name[0].toUpperCase() ?? 'U',
                          style: GoogleFonts.outfit(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user?.name ?? 'Guest User',
                            style: GoogleFonts.outfit(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: -0.3,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '@${user?.username ?? 'guest'}',
                            style: GoogleFonts.inter(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              user?.role.toUpperCase() ?? 'USER',
                              style: GoogleFonts.sourceCodePro(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 10,
                                letterSpacing: 2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1),

              const SizedBox(height: 20),

              // ─── Stats as horizontal pills ────────
              Row(
                children: [
                  _buildStatPill(totalTickets.toString(), 'Total', AppColors.primary, isDark),
                  const SizedBox(width: 10),
                  _buildStatPill(completedTickets.toString(), 'Selesai', AppColors.statusDone, isDark),
                  const SizedBox(width: 10),
                  _buildStatPill(pendingTickets.toString(), 'Pending', AppColors.statusPending, isDark),
                ],
              ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1),

              const SizedBox(height: 32),

              // ─── Preferences ─────────────────────
              Text(
                'PREFERENSI',
                style: GoogleFonts.sourceCodePro(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.textDarkSecondary : AppColors.textTertiary,
                  letterSpacing: 2,
                ),
              ).animate().fadeIn(delay: 300.ms),
              const SizedBox(height: 12),

              _buildMenuItem(
                icon: Icons.dark_mode_outlined,
                title: 'Mode Gelap',
                isDark: isDark,
                trailing: Transform.scale(
                  scale: 0.85,
                  child: Switch.adaptive(
                    value: themeMode == ThemeMode.dark,
                    onChanged: (value) =>
                        ref.read(themeNotifierProvider.notifier).toggleTheme(),
                    activeColor: AppColors.primary,
                  ),
                ),
              ).animate().fadeIn(delay: 350.ms).slideX(begin: 0.04),

              _buildMenuItem(
                icon: Icons.language_rounded,
                title: 'Bahasa',
                subtitle: 'Indonesia',
                isDark: isDark,
              ).animate().fadeIn(delay: 400.ms).slideX(begin: 0.04),

              const SizedBox(height: 24),

              // ─── Support ──────────────────────────
              Text(
                'BANTUAN',
                style: GoogleFonts.sourceCodePro(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.textDarkSecondary : AppColors.textTertiary,
                  letterSpacing: 2,
                ),
              ).animate().fadeIn(delay: 450.ms),
              const SizedBox(height: 12),

              _buildMenuItem(
                icon: Icons.help_outline_rounded,
                title: 'Pusat Bantuan',
                isDark: isDark,
                onTap: () {},
              ).animate().fadeIn(delay: 500.ms).slideX(begin: 0.04),

              _buildMenuItem(
                icon: Icons.info_outline_rounded,
                title: 'Tentang Aplikasi',
                isDark: isDark,
                onTap: () {},
              ).animate().fadeIn(delay: 550.ms).slideX(begin: 0.04),

              const SizedBox(height: 24),

              // ─── Danger Zone ──────────────────────
              Text(
                'AKUN',
                style: GoogleFonts.sourceCodePro(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.error.withOpacity(0.7),
                  letterSpacing: 2,
                ),
              ).animate().fadeIn(delay: 600.ms),
              const SizedBox(height: 12),

              _buildMenuItem(
                icon: Icons.logout_rounded,
                title: 'Keluar dari Akun',
                isDark: isDark,
                isDestructive: true,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      backgroundColor: isDark ? AppColors.cardDark : Colors.white,
                      title: Text(
                        'Keluar',
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : AppColors.textPrimary,
                        ),
                      ),
                      content: Text(
                        'Apakah Anda yakin ingin keluar dari akun?',
                        style: GoogleFonts.inter(
                          color: isDark ? AppColors.textDarkSecondary : AppColors.textSecondary,
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: Text(
                            'Batal',
                            style: GoogleFonts.outfit(
                              color: isDark ? AppColors.textDarkSecondary : AppColors.textSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(ctx);
                            ref.read(authNotifierProvider.notifier).logout();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.error,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(0, 44),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: Text(
                            'Keluar',
                            style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ).animate().fadeIn(delay: 650.ms).slideX(begin: 0.04),

              const SizedBox(height: 32),

              Center(
                child: Text(
                  'E-Ticket Helpdesk v1.0.0',
                  style: GoogleFonts.sourceCodePro(
                    fontSize: 11,
                    color: isDark ? AppColors.textDarkSecondary : AppColors.textTertiary,
                    letterSpacing: 1,
                  ),
                ),
              ).animate().fadeIn(delay: 700.ms),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Stat Pill (expanded) ─────────────────────────
  Widget _buildStatPill(String value, String label, Color color, bool isDark) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isDark ? AppColors.borderDark : AppColors.borderLight.withOpacity(0.4),
          ),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: GoogleFonts.outfit(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: color,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 11,
                color: isDark ? AppColors.textDarkSecondary : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Menu Item (flat, no card wrapper) ────────────
  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required bool isDark,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
    bool isDestructive = false,
  }) {
    final color = isDestructive ? AppColors.error : AppColors.primary;
    final textColor = isDestructive
        ? AppColors.error
        : (isDark ? Colors.white : AppColors.textPrimary);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark
                ? AppColors.borderDark
                : (isDestructive ? AppColors.error.withOpacity(0.1) : AppColors.borderLight.withOpacity(0.3)),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(isDark ? 0.08 : 0.05),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: textColor,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: isDark ? AppColors.textDarkSecondary : AppColors.textTertiary,
                      ),
                    ),
                ],
              ),
            ),
            trailing ??
                Icon(
                  Icons.chevron_right_rounded,
                  color: isDark ? AppColors.textDarkSecondary : AppColors.textTertiary,
                  size: 20,
                ),
          ],
        ),
      ),
    );
  }
}
