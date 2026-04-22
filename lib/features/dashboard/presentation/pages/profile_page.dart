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
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ─── Header ─────────────────────────────
            Stack(
              clipBehavior: Clip.none,
              children: [
                // Gradient background
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: AppColors.premiumGradient,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(36),
                      bottomRight: Radius.circular(36),
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Decorative shapes
                      Positioned(
                        top: -30,
                        right: -20,
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.06),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        left: -30,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white.withOpacity(0.04),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Avatar
                Positioned(
                  bottom: -46,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDark ? AppColors.backgroundDark : Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 24,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Container(
                        width: 88,
                        height: 88,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: AppColors.primaryGradient,
                        ),
                        child: Center(
                          child: Text(
                            user?.name[0].toUpperCase() ?? 'U',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 36,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),
                ),

                // Header title
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Profil',
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        IconButton(
                          icon: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.edit_outlined, color: Colors.white, size: 18),
                          ),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 56),

            // ─── User Info ──────────────────────────
            Column(
              children: [
                Text(
                  user?.name ?? 'Guest User',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : AppColors.textPrimary,
                  ),
                ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.15),

                const SizedBox(height: 4),

                Text(
                  '@${user?.username ?? 'guest'}',
                  style: GoogleFonts.plusJakartaSans(
                    color: isDark ? AppColors.textDarkSecondary : AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.15),

                const SizedBox(height: 12),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(isDark ? 0.15 : 0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    user?.role.toUpperCase() ?? 'USER',
                    style: GoogleFonts.plusJakartaSans(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                      fontSize: 11,
                      letterSpacing: 1.5,
                    ),
                  ),
                ).animate().fadeIn(delay: 400.ms).scale(),
              ],
            ),

            const SizedBox(height: 28),

            // ─── Stats Row ──────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.cardDark : Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: isDark ? AppColors.borderDark : AppColors.borderLight.withOpacity(0.5),
                  ),
                  boxShadow: isDark ? [] : AppColors.softShadow,
                ),
                child: Row(
                  children: [
                    _buildStatItem('Total', totalTickets.toString(), AppColors.primary, isDark),
                    _buildDivider(isDark),
                    _buildStatItem('Selesai', completedTickets.toString(), AppColors.statusDone, isDark),
                    _buildDivider(isDark),
                    _buildStatItem('Pending', pendingTickets.toString(), AppColors.statusPending, isDark),
                  ],
                ),
              ),
            ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.1),

            const SizedBox(height: 28),

            // ─── Settings ───────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'PENGATURAN',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.textDarkSecondary : AppColors.textTertiary,
                      letterSpacing: 1.5,
                    ),
                  ).animate().fadeIn(delay: 600.ms),
                  const SizedBox(height: 12),

                  _buildSettingsCard(
                    context,
                    isDark: isDark,
                    items: [
                      _buildSettingsItem(
                        icon: Icons.dark_mode_outlined,
                        title: 'Mode Gelap',
                        isDark: isDark,
                        trailing: Switch.adaptive(
                          value: themeMode == ThemeMode.dark,
                          onChanged: (value) =>
                              ref.read(themeNotifierProvider.notifier).toggleTheme(),
                          activeColor: AppColors.primary,
                        ),
                      ),
                      Divider(
                        height: 1,
                        indent: 56,
                        color: isDark ? AppColors.borderDark : AppColors.dividerLight,
                      ),
                      _buildSettingsItem(
                        icon: Icons.language_rounded,
                        title: 'Bahasa',
                        isDark: isDark,
                        trailing: Text(
                          'Indonesia',
                          style: GoogleFonts.plusJakartaSans(
                            color: isDark ? AppColors.textDarkSecondary : AppColors.textTertiary,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ).animate().fadeIn(delay: 700.ms).slideX(begin: 0.05),

                  const SizedBox(height: 20),

                  Text(
                    'DUKUNGAN',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.textDarkSecondary : AppColors.textTertiary,
                      letterSpacing: 1.5,
                    ),
                  ).animate().fadeIn(delay: 800.ms),
                  const SizedBox(height: 12),

                  _buildSettingsCard(
                    context,
                    isDark: isDark,
                    items: [
                      _buildSettingsItem(
                        icon: Icons.help_outline_rounded,
                        title: 'Pusat Bantuan',
                        isDark: isDark,
                        onTap: () {},
                      ),
                      Divider(
                        height: 1,
                        indent: 56,
                        color: isDark ? AppColors.borderDark : AppColors.dividerLight,
                      ),
                      _buildSettingsItem(
                        icon: Icons.info_outline_rounded,
                        title: 'Tentang Aplikasi',
                        isDark: isDark,
                        onTap: () {},
                      ),
                    ],
                  ).animate().fadeIn(delay: 900.ms).slideX(begin: 0.05),

                  const SizedBox(height: 28),

                  // ─── Logout Button ────────────────
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            backgroundColor: isDark ? AppColors.cardDark : Colors.white,
                            title: Text(
                              'Keluar',
                              style: GoogleFonts.plusJakartaSans(
                                fontWeight: FontWeight.w700,
                                color: isDark ? Colors.white : AppColors.textPrimary,
                              ),
                            ),
                            content: Text(
                              'Apakah Anda yakin ingin keluar dari akun?',
                              style: GoogleFonts.plusJakartaSans(
                                color: isDark ? AppColors.textDarkSecondary : AppColors.textSecondary,
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx),
                                child: Text(
                                  'Batal',
                                  style: GoogleFonts.plusJakartaSans(
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
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text(
                                  'Keluar',
                                  style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      icon: const Icon(Icons.logout_rounded, size: 18),
                      label: Text(
                        'Keluar dari Akun',
                        style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDark
                            ? AppColors.error.withOpacity(0.12)
                            : AppColors.errorSoft,
                        foregroundColor: AppColors.error,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        minimumSize: const Size(double.infinity, 56),
                      ),
                    ),
                  ).animate().fadeIn(delay: 1000.ms).slideY(begin: 0.1),

                  const SizedBox(height: 28),

                  // Version info
                  Center(
                    child: Text(
                      'E-Ticket Helpdesk v1.0.0',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: isDark ? AppColors.textDarkSecondary : AppColors.textTertiary,
                      ),
                    ),
                  ).animate().fadeIn(delay: 1100.ms),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color, bool isDark) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: color,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.textDarkSecondary : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(bool isDark) {
    return Container(
      width: 1,
      height: 36,
      color: isDark ? AppColors.borderDark : AppColors.dividerLight,
    );
  }

  Widget _buildSettingsCard(
    BuildContext context, {
    required bool isDark,
    required List<Widget> items,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight.withOpacity(0.5),
        ),
        boxShadow: isDark ? [] : AppColors.softShadow,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(children: items),
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required bool isDark,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(isDark ? 0.12 : 0.06),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: AppColors.primary, size: 20),
      ),
      title: Text(
        title,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: isDark ? Colors.white : AppColors.textPrimary,
        ),
      ),
      trailing: trailing ??
          Icon(
            Icons.chevron_right_rounded,
            color: isDark ? AppColors.textDarkSecondary : AppColors.textTertiary,
            size: 20,
          ),
      onTap: onTap,
    );
  }
}
