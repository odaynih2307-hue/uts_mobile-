import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/ticket_provider.dart';

class TicketDetailPage extends ConsumerWidget {
  final String ticketId;
  const TicketDetailPage({super.key, required this.ticketId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ticketAsync = ref.watch(ticketDetailProvider(ticketId));
    final user = ref.watch(authNotifierProvider).user;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: ticketAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
        data: (ticket) {
          final statusInfo = _getStatusInfo(ticket.status);
          final priorityInfo = _getPriorityInfo(ticket.priority);
          final comments = ticket.comments as List<dynamic>;

          return Stack(
            children: [
              SafeArea(
                child: Column(
                  children: [
                    // ─── Top Bar (flat, no gradient) ──────
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
                              child: Icon(Icons.arrow_back_ios_new_rounded, size: 16,
                                color: isDark ? Colors.white : AppColors.textPrimary),
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          const Spacer(),
                          Text('#${ticket.id.substring(0, 6).toUpperCase()}',
                            style: GoogleFonts.sourceCodePro(fontSize: 13, fontWeight: FontWeight.w600,
                              color: isDark ? AppColors.textDarkSecondary : AppColors.textTertiary)),
                          const Spacer(),
                          const SizedBox(width: 48),
                        ],
                      ),
                    ),

                    // ─── Scrollable Content ──────────────
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(24, 16, 24, 100),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Status + Priority row
                            Row(
                              children: [
                                _chip(statusInfo['label']!, statusInfo['color']! as Color, isDark),
                                const SizedBox(width: 8),
                                _chip(priorityInfo['label']!, priorityInfo['color']! as Color, isDark),
                              ],
                            ).animate().fadeIn(),

                            const SizedBox(height: 16),

                            // Title
                            Text(ticket.title,
                              style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.w800,
                                color: isDark ? Colors.white : AppColors.textPrimary, height: 1.2, letterSpacing: -0.5),
                            ).animate().fadeIn(delay: 100.ms),

                            const SizedBox(height: 20),

                            // Info row (inline, not cards)
                            _infoRow(Icons.person_outline_rounded, 'Pembuat', ticket.creatorName, isDark),
                            const SizedBox(height: 10),
                            _infoRow(Icons.support_agent_rounded, 'Petugas',
                              ticket.assigneeName ?? 'Belum ditugaskan', isDark),
                            const SizedBox(height: 10),
                            _infoRow(Icons.calendar_today_outlined, 'Tanggal',
                              '${ticket.createdAt.day}/${ticket.createdAt.month}/${ticket.createdAt.year}', isDark),

                            const SizedBox(height: 24),

                            // Description
                            Text('DESKRIPSI', style: GoogleFonts.sourceCodePro(fontSize: 11,
                              fontWeight: FontWeight.w600, color: isDark ? AppColors.textDarkSecondary : AppColors.textTertiary, letterSpacing: 2)),
                            const SizedBox(height: 10),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(18),
                              decoration: BoxDecoration(
                                color: isDark ? AppColors.cardDark : AppColors.surfaceElevatedLight,
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Text(ticket.description,
                                style: GoogleFonts.inter(fontSize: 14, height: 1.7,
                                  color: isDark ? AppColors.textLight : AppColors.textPrimary)),
                            ).animate().fadeIn(delay: 200.ms),

                            // Attachment
                            if (ticket.imagePath != null) ...[
                              const SizedBox(height: 24),
                              Text('LAMPIRAN', style: GoogleFonts.sourceCodePro(fontSize: 11,
                                fontWeight: FontWeight.w600, color: isDark ? AppColors.textDarkSecondary : AppColors.textTertiary, letterSpacing: 2)),
                              const SizedBox(height: 10),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(18),
                                child: Image.file(File(ticket.imagePath!), height: 200,
                                  width: double.infinity, fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(height: 100,
                                    decoration: BoxDecoration(
                                      color: isDark ? AppColors.surfaceElevatedDark : AppColors.surfaceElevatedLight,
                                      borderRadius: BorderRadius.circular(18)),
                                    child: Center(child: Icon(Icons.broken_image_outlined, size: 32,
                                      color: isDark ? AppColors.textDarkSecondary : AppColors.textTertiary)))),
                              ).animate().fadeIn(delay: 250.ms),
                            ],

                            // Comments
                            const SizedBox(height: 24),
                            Row(
                              children: [
                                Text('KOMENTAR', style: GoogleFonts.sourceCodePro(fontSize: 11,
                                  fontWeight: FontWeight.w600, color: isDark ? AppColors.textDarkSecondary : AppColors.textTertiary, letterSpacing: 2)),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(6)),
                                  child: Text('${comments.length}', style: GoogleFonts.sourceCodePro(
                                    fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),

                            if (comments.isEmpty)
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(vertical: 32),
                                decoration: BoxDecoration(
                                  color: isDark ? AppColors.cardDark : AppColors.surfaceElevatedLight,
                                  borderRadius: BorderRadius.circular(18)),
                                child: Column(children: [
                                  Icon(Icons.chat_bubble_outline_rounded, size: 32,
                                    color: isDark ? AppColors.textDarkSecondary : AppColors.textTertiary),
                                  const SizedBox(height: 8),
                                  Text('Belum ada komentar', style: GoogleFonts.inter(fontSize: 13,
                                    color: isDark ? AppColors.textDarkSecondary : AppColors.textTertiary)),
                                ]))
                            else
                              ...comments.map((c) => _buildCommentBubble(c, isDark)),

                            const SizedBox(height: 16),
                            _CommentInputWidget(ticketId: ticket.id),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Admin actions
              if (user?.role == 'admin' || user?.role == 'helpdesk')
                Positioned(
                  bottom: 0, left: 0, right: 0,
                  child: _buildAdminBar(context, ref, ticketId, isDark)
                    .animate().slideY(begin: 1, delay: 400.ms),
                ),
            ],
          );
        },
      ),
    );
  }

  Map<String, dynamic> _getStatusInfo(String status) {
    switch (status) {
      case 'pending': return {'label': 'PENDING', 'color': AppColors.statusPending};
      case 'proses': return {'label': 'DIPROSES', 'color': AppColors.statusProcess};
      case 'selesai': return {'label': 'SELESAI', 'color': AppColors.statusDone};
      default: return {'label': status.toUpperCase(), 'color': AppColors.textTertiary};
    }
  }

  Map<String, dynamic> _getPriorityInfo(String? priority) {
    switch (priority) {
      case 'low': return {'label': 'RENDAH', 'color': AppColors.success};
      case 'high': return {'label': 'TINGGI', 'color': AppColors.error};
      default: return {'label': 'SEDANG', 'color': Colors.orange};
    }
  }

  Widget _chip(String label, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(isDark ? 0.12 : 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.25))),
      child: Text(label, style: GoogleFonts.sourceCodePro(
        color: color, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1)),
    );
  }

  Widget _infoRow(IconData icon, String label, String value, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight.withOpacity(0.3))),
      child: Row(children: [
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(width: 12),
        Text(label, style: GoogleFonts.inter(fontSize: 12, color: isDark ? AppColors.textDarkSecondary : AppColors.textTertiary)),
        const Spacer(),
        Flexible(child: Text(value, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600,
          color: isDark ? Colors.white : AppColors.textPrimary), overflow: TextOverflow.ellipsis)),
      ]),
    );
  }

  Widget _buildCommentBubble(dynamic comment, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight.withOpacity(0.3))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            width: 28, height: 28,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(9)),
            child: Center(child: Text(comment.userName[0].toUpperCase(),
              style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary)))),
          const SizedBox(width: 10),
          Text(comment.userName, style: GoogleFonts.outfit(fontWeight: FontWeight.w600, fontSize: 13,
            color: isDark ? Colors.white : AppColors.textPrimary)),
          const Spacer(),
          Text('${comment.createdAt.hour}:${comment.createdAt.minute.toString().padLeft(2, '0')}',
            style: GoogleFonts.inter(fontSize: 11, color: isDark ? AppColors.textDarkSecondary : AppColors.textTertiary)),
        ]),
        const SizedBox(height: 10),
        Text(comment.message, style: GoogleFonts.inter(fontSize: 13, height: 1.5,
          color: isDark ? AppColors.textLight : AppColors.textPrimary)),
      ]),
    );
  }

  Widget _buildAdminBar(BuildContext context, WidgetRef ref, String id, bool isDark) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        border: Border(top: BorderSide(color: isDark ? AppColors.borderDark : AppColors.dividerLight))),
      child: SafeArea(
        top: false,
        child: Row(children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => _showAssignDialog(context, ref, id),
              icon: const Icon(Icons.person_add_alt_1_rounded, size: 18),
              label: Text('Tugaskan', style: GoogleFonts.outfit(fontWeight: FontWeight.w600)),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: BorderSide(color: isDark ? AppColors.borderDark : AppColors.primary.withOpacity(0.3)),
                minimumSize: const Size(0, 52),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => _showStatusDialog(context, ref, id),
              icon: const Icon(Icons.swap_horiz_rounded, size: 18),
              label: Text('Ubah Status', style: GoogleFonts.outfit(fontWeight: FontWeight.w600)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                minimumSize: const Size(0, 52),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
            ),
          ),
        ]),
      ),
    );
  }

  void _showAssignDialog(BuildContext context, WidgetRef ref, String id) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final responders = [
      {'id': 'h1', 'name': 'Budi - Networking'},
      {'id': 'h2', 'name': 'Siti - Software'},
      {'id': 'h3', 'name': 'Agus - Hardware'},
    ];
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      backgroundColor: isDark ? AppColors.cardDark : Colors.white,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(
            color: isDark ? AppColors.borderDark : AppColors.borderLight, borderRadius: BorderRadius.circular(2)))),
          const SizedBox(height: 20),
          Text('Tugaskan Petugas', style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : AppColors.textPrimary)),
          const SizedBox(height: 6),
          Text('Pilih petugas penanggung jawab', style: GoogleFonts.inter(fontSize: 13,
            color: isDark ? AppColors.textDarkSecondary : AppColors.textSecondary)),
          const SizedBox(height: 20),
          ...responders.map((r) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceElevatedDark : AppColors.surfaceElevatedLight,
              borderRadius: BorderRadius.circular(14)),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              leading: Container(width: 40, height: 40, decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                child: Center(child: Text(r['name']![0], style: GoogleFonts.outfit(
                  fontWeight: FontWeight.w700, color: AppColors.primary)))),
              title: Text(r['name']!, style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14,
                color: isDark ? Colors.white : AppColors.textPrimary)),
              trailing: Icon(Icons.arrow_forward_ios_rounded, size: 14,
                color: isDark ? AppColors.textDarkSecondary : AppColors.textTertiary),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              onTap: () {
                ref.read(ticketListNotifierProvider.notifier).updateStatus(id, 'proses',
                  assigneeId: r['id'], assigneeName: r['name']);
                Navigator.pop(context);
                ref.invalidate(ticketDetailProvider(id));
              }),
          )),
          const SizedBox(height: 12),
        ]),
      ),
    );
  }

  void _showStatusDialog(BuildContext context, WidgetRef ref, String id) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final statuses = [
      {'key': 'proses', 'label': 'DIPROSES', 'color': AppColors.statusProcess, 'icon': Icons.sync_rounded},
      {'key': 'selesai', 'label': 'SELESAI', 'color': AppColors.statusDone, 'icon': Icons.check_circle_rounded},
      {'key': 'batal', 'label': 'DIBATALKAN', 'color': AppColors.statusCancel, 'icon': Icons.cancel_rounded},
    ];
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      backgroundColor: isDark ? AppColors.cardDark : Colors.white,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(
            color: isDark ? AppColors.borderDark : AppColors.borderLight, borderRadius: BorderRadius.circular(2)))),
          const SizedBox(height: 20),
          Text('Perbarui Status', style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : AppColors.textPrimary)),
          const SizedBox(height: 20),
          ...statuses.map((s) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: isDark ? (s['color'] as Color).withOpacity(0.08) : (s['color'] as Color).withOpacity(0.05),
              borderRadius: BorderRadius.circular(14)),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              leading: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(
                color: (s['color'] as Color).withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
                child: Icon(s['icon'] as IconData, color: s['color'] as Color, size: 20)),
              title: Text(s['label'] as String, style: GoogleFonts.outfit(fontWeight: FontWeight.w700,
                fontSize: 13, color: s['color'] as Color, letterSpacing: 0.5)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              onTap: () {
                ref.read(ticketListNotifierProvider.notifier).updateStatus(id, s['key'] as String);
                Navigator.pop(context);
                ref.invalidate(ticketDetailProvider(id));
              }),
          )),
          const SizedBox(height: 12),
        ]),
      ),
    );
  }
}

class _CommentInputWidget extends ConsumerStatefulWidget {
  final String ticketId;
  const _CommentInputWidget({required this.ticketId});

  @override
  ConsumerState<_CommentInputWidget> createState() => _CommentInputWidgetState();
}

class _CommentInputWidgetState extends ConsumerState<_CommentInputWidget> {
  final _controller = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() { _controller.dispose(); super.dispose(); }

  void _submitComment() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    final user = ref.read(authNotifierProvider).user;
    if (user == null) return;
    setState(() => _isSubmitting = true);
    final success = await ref.read(ticketListNotifierProvider.notifier)
        .addComment(widget.ticketId, user.id, user.name, text);
    if (mounted) {
      if (success) {
        _controller.clear();
        ref.invalidate(ticketDetailProvider(widget.ticketId));
      }
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceElevatedDark : AppColors.surfaceElevatedLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight.withOpacity(0.5))),
      child: Row(children: [
        Expanded(child: TextField(
          controller: _controller,
          style: GoogleFonts.inter(color: isDark ? Colors.white : AppColors.textPrimary, fontSize: 14),
          maxLines: null,
          decoration: InputDecoration(
            hintText: 'Tulis komentar...', hintStyle: GoogleFonts.inter(
              color: isDark ? AppColors.textDarkSecondary : AppColors.textTertiary),
            border: InputBorder.none, isDense: true,
            contentPadding: const EdgeInsets.symmetric(vertical: 14)))),
        const SizedBox(width: 8),
        _isSubmitting
            ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
            : IconButton(icon: const Icon(Icons.send_rounded), color: AppColors.primary, onPressed: _submitComment),
      ]),
    );
  }
}
