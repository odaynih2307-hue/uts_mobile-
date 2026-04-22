import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animations/animations.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/ticket_provider.dart';
import 'create_ticket_page.dart';
import 'ticket_detail_page.dart';

class TicketListPage extends ConsumerWidget {
  const TicketListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ticketState = ref.watch(ticketListNotifierProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Header & Search Combined ─────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Tiket',
                        style: GoogleFonts.outfit(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: isDark ? Colors.white : AppColors.textPrimary,
                          letterSpacing: -0.5,
                        ),
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => ref.read(ticketListNotifierProvider.notifier).toggleSortOrder(),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: isDark ? AppColors.surfaceElevatedDark : AppColors.surfaceElevatedLight,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                ticketState.isDescending
                                    ? Icons.arrow_downward_rounded
                                    : Icons.arrow_upward_rounded,
                                color: AppColors.primary,
                                size: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Search bar — wider, simpler
                  Container(
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.surfaceElevatedDark : AppColors.surfaceElevatedLight,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: TextField(
                      onChanged: (value) =>
                          ref.read(ticketListNotifierProvider.notifier).setSearchQuery(value),
                      style: GoogleFonts.inter(fontSize: 14),
                      decoration: InputDecoration(
                        hintText: 'Cari tiket...',
                        prefixIcon: Icon(
                          Icons.search_rounded,
                          size: 20,
                          color: isDark ? AppColors.textDarkSecondary : AppColors.textTertiary,
                        ),
                        filled: false,
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms),

            const SizedBox(height: 12),

            // ─── Filter Chips as Scrollable Row ───────
            SizedBox(
              height: 42,
              child: _buildFilterBar(ref, ticketState.filterStatus, isDark),
            ).animate().fadeIn(delay: 100.ms).slideY(begin: -0.1),

            const SizedBox(height: 8),

            // ─── Ticket Count ─────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
              child: Text(
                '${ticketState.filteredTickets.length} tiket ditemukan',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: isDark ? AppColors.textDarkSecondary : AppColors.textTertiary,
                ),
              ),
            ).animate().fadeIn(delay: 150.ms),

            // ─── Ticket List ──────────────────────────
            Expanded(
              child: ticketState.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ticketState.filteredTickets.isEmpty
                      ? _buildEmptyState(isDark)
                      : RefreshIndicator(
                          onRefresh: () =>
                              ref.read(ticketListNotifierProvider.notifier).loadTickets(),
                          color: AppColors.primary,
                          child: ListView.builder(
                            padding: const EdgeInsets.fromLTRB(24, 4, 24, 100),
                            itemCount: ticketState.filteredTickets.length,
                            itemBuilder: (context, index) {
                              final ticket = ticketState.filteredTickets[index];
                              return GestureDetector(
                                onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(builder: (_) => TicketDetailPage(ticketId: ticket.id)),
                                ),
                                child: _buildTicketCard(ticket, isDark),
                              ).animate()
                                  .fadeIn(delay: (index * 60).ms, duration: 400.ms)
                                  .slideY(begin: 0.06);
                            },
                          ),
                        ),
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 60),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const CreateTicketPage()),
            );
          },
          backgroundColor: AppColors.primary,
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
        ),
      ).animate().scale(delay: 400.ms, curve: Curves.easeOutBack),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.primary.withOpacity(0.06)
                  : AppColors.primarySoft,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Icon(
              Icons.search_off_rounded,
              size: 44,
              color: isDark ? AppColors.primaryLight : AppColors.primary.withOpacity(0.4),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Tidak ada tiket ditemukan',
            style: GoogleFonts.outfit(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.textDarkSecondary : AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Buat tiket baru untuk memulai',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: isDark ? AppColors.textDarkSecondary : AppColors.textTertiary,
            ),
          ),
        ],
      ),
    ).animate().fadeIn();
  }

  Widget _buildFilterBar(WidgetRef ref, String currentFilter, bool isDark) {
    final filters = [
      {'key': 'semua', 'label': 'Semua'},
      {'key': 'pending', 'label': 'Pending'},
      {'key': 'proses', 'label': 'Proses'},
      {'key': 'selesai', 'label': 'Selesai'},
    ];

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: filters.length,
      itemBuilder: (context, index) {
        final filter = filters[index];
        final isSelected = currentFilter == filter['key'];

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: GestureDetector(
            onTap: () {
              ref.read(ticketListNotifierProvider.notifier)
                  .setFilter(filter['key'] as String);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary
                      : (isDark ? AppColors.borderDark : AppColors.borderLight),
                ),
              ),
              child: Text(
                filter['label'] as String,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected
                      ? Colors.white
                      : (isDark ? AppColors.textDarkSecondary : AppColors.textSecondary),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ─── Ticket Card: Compact row with top status dot ───
  Widget _buildTicketCard(dynamic ticket, bool isDark) {
    Color statusColor;
    switch (ticket.status) {
      case 'pending':
        statusColor = AppColors.statusPending;
        break;
      case 'proses':
        statusColor = AppColors.statusProcess;
        break;
      case 'selesai':
        statusColor = AppColors.statusDone;
        break;
      default:
        statusColor = AppColors.textTertiary;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: status + ID
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: statusColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                ticket.status.toUpperCase(),
                style: GoogleFonts.sourceCodePro(
                  color: statusColor,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                ),
              ),
              const Spacer(),
              Text(
                '#${ticket.id.substring(0, 6).toUpperCase()}',
                style: GoogleFonts.sourceCodePro(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: isDark ? AppColors.textDarkSecondary : AppColors.textTertiary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Title
          Text(
            ticket.title,
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: isDark ? Colors.white : AppColors.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            ticket.description,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              color: isDark ? AppColors.textDarkSecondary : AppColors.textSecondary,
              fontSize: 13,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          // Bottom row
          Row(
            children: [
              Icon(
                Icons.calendar_today_outlined,
                size: 12,
                color: isDark ? AppColors.textDarkSecondary : AppColors.textTertiary,
              ),
              const SizedBox(width: 5),
              Text(
                '${ticket.createdAt.day}/${ticket.createdAt.month}/${ticket.createdAt.year}',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: isDark ? AppColors.textDarkSecondary : AppColors.textTertiary,
                ),
              ),
              if (ticket.assigneeName != null) ...[
                const Spacer(),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.person_rounded, size: 12, color: AppColors.primary),
                    const SizedBox(width: 4),
                    Text(
                      ticket.assigneeName!,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
