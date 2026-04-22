import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animations/animations.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../ticket/presentation/pages/ticket_list_page.dart';
import '../../../ticket/presentation/pages/ticket_detail_page.dart';
import '../../../ticket/presentation/providers/ticket_provider.dart';
import 'package:project_uts/features/notification/presentation/pages/notification_page.dart';
import 'profile_page.dart';
import 'report_preview_page.dart';

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const DashboardSummaryView(),
    const TicketListPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: PageTransitionSwitcher(
        duration: const Duration(milliseconds: 400),
        transitionBuilder: (child, primaryAnimation, secondaryAnimation) {
          return FadeThroughTransition(
            animation: primaryAnimation,
            secondaryAnimation: secondaryAnimation,
            child: child,
          );
        },
        child: _pages[_currentIndex],
      ),
      extendBody: true,
      bottomNavigationBar: _buildBottomNav(isDark),
    );
  }

  // ─── Bottom Nav: dock-style with vertical icon+label ──
  Widget _buildBottomNav(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.borderDark : AppColors.dividerLight,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: [
              _buildNavTab(0, Icons.space_dashboard_outlined, Icons.space_dashboard_rounded, 'Beranda', isDark),
              _buildNavTab(1, Icons.receipt_long_outlined, Icons.receipt_long_rounded, 'Tiket', isDark),
              _buildNavTab(2, Icons.person_outline_rounded, Icons.person_rounded, 'Profil', isDark),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavTab(int index, IconData icon, IconData activeIcon, String label, bool isDark) {
    final isSelected = _currentIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _currentIndex = index),
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Active indicator line
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: isSelected ? 24 : 0,
              height: 3,
              margin: const EdgeInsets.only(bottom: 6),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Icon(
              isSelected ? activeIcon : icon,
              size: 22,
              color: isSelected
                  ? AppColors.primary
                  : (isDark ? AppColors.textDarkSecondary : AppColors.textTertiary),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected
                    ? AppColors.primary
                    : (isDark ? AppColors.textDarkSecondary : AppColors.textTertiary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────
// Dashboard Summary View
// ──────────────────────────────────────────────────────
class DashboardSummaryView extends ConsumerWidget {
  const DashboardSummaryView({super.key});

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 11) return 'Selamat Pagi';
    if (hour < 15) return 'Selamat Siang';
    if (hour < 18) return 'Selamat Sore';
    return 'Selamat Malam';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authNotifierProvider).user;
    final ticketState = ref.watch(ticketListNotifierProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final totalTickets = ticketState.tickets.length;
    final pendingTickets = ticketState.tickets.where((t) => t.status == 'pending').length;
    final activeTickets = ticketState.tickets.where((t) => t.status == 'proses').length;
    final completedTickets = ticketState.tickets.where((t) => t.status == 'selesai').length;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ─── Hero Header with greeting ──────────────
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                gradient: AppColors.premiumGradient,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(32),
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top Row: avatar + notification
                      Row(
                        children: [
                          // Avatar
                          Container(
                            width: 46,
                            height: 46,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.white.withOpacity(0.1)),
                            ),
                            child: Center(
                              child: Text(
                                user?.name[0].toUpperCase() ?? 'U',
                                style: GoogleFonts.outfit(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _getGreeting(),
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: Colors.white.withOpacity(0.6),
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  user?.name ?? 'User',
                                  style: GoogleFonts.outfit(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    letterSpacing: -0.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Notification
                          GestureDetector(
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => const NotificationPage()),
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: Colors.white.withOpacity(0.08)),
                              ),
                              child: const Icon(
                                Icons.notifications_none_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ).animate().fadeIn(duration: 400.ms),

                      const SizedBox(height: 28),

                      // Quick stats row inside header
                      Row(
                        children: [
                          _buildHeaderStat('Total', totalTickets.toString()),
                          const SizedBox(width: 10),
                          _buildHeaderStat('Aktif', activeTickets.toString()),
                          const SizedBox(width: 10),
                          _buildHeaderStat('Pending', pendingTickets.toString()),
                          const SizedBox(width: 10),
                          _buildHeaderStat('Selesai', completedTickets.toString()),
                        ],
                      ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.15),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ─── Body Content ───────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ─── Admin Report ──────────────────────
                  if (user?.role == 'admin' || user?.role == 'helpdesk')
                    _buildAdminReportCard(context, ticketState, isDark)
                        .animate().fadeIn(delay: 300.ms).slideY(begin: 0.1),

                  if (user?.role == 'admin' || user?.role == 'helpdesk')
                    const SizedBox(height: 24),

                  // ─── Quick Actions Grid ─────────────────
                  Text(
                    'AKSI CEPAT',
                    style: GoogleFonts.sourceCodePro(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.textDarkSecondary : AppColors.textTertiary,
                      letterSpacing: 2,
                    ),
                  ).animate().fadeIn(delay: 400.ms),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: _buildQuickAction(
                          icon: Icons.add_circle_outline_rounded,
                          label: 'Buat Tiket',
                          color: AppColors.primary,
                          isDark: isDark,
                          onTap: () {},
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildQuickAction(
                          icon: Icons.search_rounded,
                          label: 'Cari Tiket',
                          color: AppColors.statusProcess,
                          isDark: isDark,
                          onTap: () {},
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildQuickAction(
                          icon: Icons.bar_chart_rounded,
                          label: 'Statistik',
                          color: AppColors.accent,
                          isDark: isDark,
                          onTap: () {},
                        ),
                      ),
                    ],
                  ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.1),

                  const SizedBox(height: 28),

                  // ─── Recent Tickets Section ─────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Tiket Terbaru',
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : AppColors.textPrimary,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(isDark ? 0.1 : 0.06),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${ticketState.tickets.length} total',
                          style: GoogleFonts.sourceCodePro(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ).animate().fadeIn(delay: 600.ms),
                  const SizedBox(height: 14),
                ],
              ),
            ),
          ),

          // ─── Ticket List (sliver) ────────────────────
          _buildRecentTicketSliver(ticketState, isDark),

          // Bottom padding
          const SliverToBoxAdapter(
            child: SizedBox(height: 100),
          ),
        ],
      ),
    );
  }

  // ─── Header inline stat pill ────────────────────────
  Widget _buildHeaderStat(String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withOpacity(0.06)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: GoogleFonts.outfit(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 10,
                color: Colors.white.withOpacity(0.5),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Quick Action Button ────────────────────────────
  Widget _buildQuickAction({
    required IconData icon,
    required String label,
    required Color color,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark ? AppColors.borderDark : AppColors.borderLight.withOpacity(0.4),
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(isDark ? 0.1 : 0.06),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Admin Report Card ──────────────────────────────
  Widget _buildAdminReportCard(BuildContext context, TicketListState ticketState, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight.withOpacity(0.4),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(Icons.analytics_rounded, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Laporan Tiket',
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Cetak ringkasan PDF',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: isDark ? AppColors.textDarkSecondary : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ReportPreviewPage(tickets: ticketState.tickets),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(isDark ? 0.1 : 0.06),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.arrow_forward_rounded, color: AppColors.primary, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Recent Tickets as Sliver ───────────────────────
  SliverPadding _buildRecentTicketSliver(TicketListState ticketState, bool isDark) {
    if (ticketState.isLoading) {
      return const SliverPadding(
        padding: EdgeInsets.all(40),
        sliver: SliverToBoxAdapter(
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    if (ticketState.tickets.isEmpty) {
      return SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        sliver: SliverToBoxAdapter(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 48),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : AppColors.surfaceElevatedLight,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: isDark ? AppColors.borderDark : AppColors.borderLight.withOpacity(0.4),
              ),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.inbox_rounded,
                  size: 48,
                  color: isDark ? AppColors.textDarkSecondary : AppColors.textTertiary,
                ),
                const SizedBox(height: 12),
                Text(
                  'Belum ada tiket',
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.textDarkSecondary : AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final recentTickets = ticketState.tickets.take(5).toList();

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverList.builder(
        itemCount: recentTickets.length,
        itemBuilder: (context, index) {
          final ticket = recentTickets[index];
          Color statusColor;
          IconData statusIcon;

          switch (ticket.status) {
            case 'pending':
              statusColor = AppColors.statusPending;
              statusIcon = Icons.schedule_rounded;
              break;
            case 'proses':
              statusColor = AppColors.statusProcess;
              statusIcon = Icons.sync_rounded;
              break;
            case 'selesai':
              statusColor = AppColors.statusDone;
              statusIcon = Icons.check_circle_rounded;
              break;
            default:
              statusColor = AppColors.textTertiary;
              statusIcon = Icons.info_outline_rounded;
          }

          return GestureDetector(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => TicketDetailPage(ticketId: ticket.id)),
            ),
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardDark : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark ? AppColors.borderDark : AppColors.borderLight.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  // Number indicator
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(isDark ? 0.1 : 0.06),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Icon(statusIcon, color: statusColor, size: 18),
                    ),
                  ),
                  const SizedBox(width: 14),
                  // Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ticket.title,
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: isDark ? Colors.white : AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              ticket.status.toUpperCase(),
                              style: GoogleFonts.sourceCodePro(
                                fontSize: 10,
                                color: statusColor,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1,
                              ),
                            ),
                            Container(
                              width: 3,
                              height: 3,
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                color: isDark ? AppColors.textDarkSecondary : AppColors.textTertiary,
                                shape: BoxShape.circle,
                              ),
                            ),
                            Text(
                              '${ticket.createdAt.day}/${ticket.createdAt.month}/${ticket.createdAt.year}',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                color: isDark ? AppColors.textDarkSecondary : AppColors.textTertiary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: isDark ? AppColors.textDarkSecondary : AppColors.textTertiary,
                    size: 20,
                  ),
                ],
              ),
            ),
          ).animate().fadeIn(delay: (700 + index * 80).ms).slideX(begin: 0.06);
        },
      ),
    );
  }
}
