import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Mock notifications grouped by time
    final todayNotifications = [
      {
        'title': 'Status Tiket Diperbarui',
        'body': 'Tiket #123 "Aplikasi Error" telah diproses oleh admin.',
        'time': '5 menit yang lalu',
        'isRead': false,
        'icon': Icons.sync_rounded,
        'color': AppColors.statusProcess,
      },
      {
        'title': 'Komentar Baru',
        'body': 'Admin membalas tiket Anda: "Mohon tunggu sebentar".',
        'time': '1 jam yang lalu',
        'isRead': false,
        'icon': Icons.chat_bubble_outline_rounded,
        'color': AppColors.primary,
      },
    ];

    final olderNotifications = [
      {
        'title': 'Tiket Selesai',
        'body': 'Tiket #120 telah ditutup dan dinyatakan selesai.',
        'time': 'Kemarin',
        'isRead': true,
        'icon': Icons.check_circle_outline_rounded,
        'color': AppColors.statusDone,
      },
    ];

    final hasNotifications = todayNotifications.isNotEmpty || olderNotifications.isNotEmpty;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            // ─── Top Bar ──────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 16, 0),
              child: Row(
                children: [
                  IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.surfaceElevatedDark : AppColors.surfaceElevatedLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 16,
                        color: isDark ? Colors.white : AppColors.textPrimary,
                      ),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const Spacer(),
                  Text(
                    'Notifikasi',
                    style: GoogleFonts.outfit(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : AppColors.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  if (hasNotifications)
                    GestureDetector(
                      onTap: () {},
                      child: Icon(
                        Icons.done_all_rounded,
                        size: 20,
                        color: AppColors.primary,
                      ),
                    )
                  else
                    const SizedBox(width: 20),
                ],
              ),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: !hasNotifications
                  ? _buildEmptyState(isDark)
                  : ListView(
                      padding: const EdgeInsets.fromLTRB(24, 10, 24, 40),
                      children: [
                        if (todayNotifications.isNotEmpty) ...[
                          _buildSectionHeader('HARI INI', isDark)
                              .animate()
                              .fadeIn(duration: 300.ms),
                          const SizedBox(height: 12),
                          ...todayNotifications.asMap().entries.map((entry) {
                            return _buildNotificationItem(entry.value, isDark)
                                .animate()
                                .fadeIn(delay: (entry.key * 100 + 100).ms, duration: 400.ms)
                                .slideX(begin: 0.05);
                          }),
                        ],
                        if (olderNotifications.isNotEmpty) ...[
                          const SizedBox(height: 28),
                          _buildSectionHeader('SEBELUMNYA', isDark)
                              .animate()
                              .fadeIn(delay: 300.ms),
                          const SizedBox(height: 12),
                          ...olderNotifications.asMap().entries.map((entry) {
                            return _buildNotificationItem(entry.value, isDark)
                                .animate()
                                .fadeIn(delay: (entry.key * 100 + 400).ms, duration: 400.ms)
                                .slideX(begin: 0.05);
                          }),
                        ],
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, bool isDark) {
    return Text(
      title,
      style: GoogleFonts.sourceCodePro(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: isDark ? AppColors.textDarkSecondary : AppColors.textTertiary,
        letterSpacing: 2,
      ),
    );
  }

  Widget _buildNotificationItem(Map<String, dynamic> item, bool isDark) {
    final isRead = item['isRead'] as bool;
    final color = item['color'] as Color;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isRead
            ? (isDark ? AppColors.surfaceDark : Colors.transparent)
            : (isDark ? AppColors.cardDark : Colors.white),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isRead
              ? (isDark ? AppColors.borderDark : AppColors.dividerLight)
              : (isDark ? AppColors.borderDark : AppColors.borderLight.withOpacity(0.5)),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dot indicator
          Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.only(top: 6),
            decoration: BoxDecoration(
              color: isRead ? Colors.transparent : color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 14),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        item['title'] as String,
                        style: GoogleFonts.outfit(
                          fontWeight: isRead ? FontWeight.w500 : FontWeight.w700,
                          fontSize: 15,
                          color: isRead
                              ? (isDark ? AppColors.textDarkSecondary : AppColors.textSecondary)
                              : (isDark ? Colors.white : AppColors.textPrimary),
                        ),
                      ),
                    ),
                    Text(
                      item['time'] as String,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: isDark ? AppColors.textDarkSecondary : AppColors.textTertiary,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  item['body'] as String,
                  style: GoogleFonts.inter(
                    color: isRead
                        ? (isDark ? AppColors.textDarkSecondary : AppColors.textTertiary)
                        : (isDark ? AppColors.textLight : AppColors.textSecondary),
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceElevatedDark : AppColors.surfaceElevatedLight,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Icon(
              Icons.notifications_off_outlined,
              size: 40,
              color: isDark ? AppColors.textDarkSecondary : AppColors.textTertiary,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Tidak Ada Notifikasi',
            style: GoogleFonts.outfit(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Anda akan melihat pemberitahuan\nbaru di halaman ini',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: isDark ? AppColors.textDarkSecondary : AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }
}
