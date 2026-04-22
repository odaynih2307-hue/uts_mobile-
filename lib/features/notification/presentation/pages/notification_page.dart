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
      appBar: AppBar(
        leading: IconButton(
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
        title: Text(
          'Notifikasi',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
        ),
        actions: [
          if (hasNotifications)
            Container(
              margin: const EdgeInsets.only(right: 12),
              child: TextButton(
                onPressed: () {},
                child: Text(
                  'Tandai Semua',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: !hasNotifications
          ? _buildEmptyState(isDark)
          : ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              children: [
                // Today section
                if (todayNotifications.isNotEmpty) ...[
                  _buildSectionHeader('Hari Ini', isDark)
                      .animate()
                      .fadeIn(duration: 300.ms),
                  const SizedBox(height: 8),
                  ...todayNotifications.asMap().entries.map((entry) {
                    return _buildNotificationCard(entry.value, isDark)
                        .animate()
                        .fadeIn(delay: (entry.key * 100 + 100).ms, duration: 400.ms)
                        .slideX(begin: 0.05);
                  }),
                ],

                // Older section
                if (olderNotifications.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  _buildSectionHeader('Sebelumnya', isDark)
                      .animate()
                      .fadeIn(delay: 300.ms),
                  const SizedBox(height: 8),
                  ...olderNotifications.asMap().entries.map((entry) {
                    return _buildNotificationCard(entry.value, isDark)
                        .animate()
                        .fadeIn(delay: (entry.key * 100 + 400).ms, duration: 400.ms)
                        .slideX(begin: 0.05);
                  }),
                ],
              ],
            ),
    );
  }

  Widget _buildSectionHeader(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 4),
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.plusJakartaSans(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: isDark ? AppColors.textDarkSecondary : AppColors.textTertiary,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> item, bool isDark) {
    final isRead = item['isRead'] as bool;
    final color = item['color'] as Color;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isDark
            ? (isRead ? AppColors.surfaceDark : AppColors.cardDark)
            : (isRead ? AppColors.surfaceElevatedLight.withOpacity(0.5) : Colors.white),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark
              ? (isRead ? AppColors.borderDark.withOpacity(0.5) : AppColors.borderDark)
              : (isRead ? Colors.transparent : AppColors.borderLight.withOpacity(0.5)),
        ),
        boxShadow: isRead
            ? []
            : [
                BoxShadow(
                  color: color.withOpacity(isDark ? 0.08 : 0.06),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isRead
                    ? (isDark ? AppColors.surfaceElevatedDark : AppColors.surfaceElevatedLight)
                    : color.withOpacity(isDark ? 0.12 : 0.08),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                item['icon'] as IconData,
                color: isRead
                    ? (isDark ? AppColors.textDarkSecondary : AppColors.textTertiary)
                    : color,
                size: 20,
              ),
            ),
            const SizedBox(width: 14),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item['title'] as String,
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: isRead ? FontWeight.w500 : FontWeight.w700,
                            fontSize: 14,
                            color: isRead
                                ? (isDark ? AppColors.textDarkSecondary : AppColors.textSecondary)
                                : (isDark ? Colors.white : AppColors.textPrimary),
                          ),
                        ),
                      ),
                      if (!isRead)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    item['body'] as String,
                    style: GoogleFonts.plusJakartaSans(
                      color: isRead
                          ? (isDark ? AppColors.textDarkSecondary : AppColors.textTertiary)
                          : (isDark ? AppColors.textDarkSecondary : AppColors.textSecondary),
                      fontSize: 13,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item['time'] as String,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      color: isDark ? AppColors.textDarkSecondary : AppColors.textTertiary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.primary.withOpacity(0.08)
                  : AppColors.primarySoft,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notifications_none_rounded,
              size: 52,
              color: isDark ? AppColors.primaryLight : AppColors.primary.withOpacity(0.4),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Tidak ada notifikasi',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Notifikasi baru akan muncul di sini',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              color: isDark ? AppColors.textDarkSecondary : AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }
}
