import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/ticket_provider.dart';

class CreateTicketPage extends ConsumerStatefulWidget {
  const CreateTicketPage({super.key});

  @override
  ConsumerState<CreateTicketPage> createState() => _CreateTicketPageState();
}

class _CreateTicketPageState extends ConsumerState<CreateTicketPage> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  File? _selectedImage;
  final _picker = ImagePicker();
  String _selectedPriority = 'medium';

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  Future<void> _takePhoto() async {
    if (Platform.isWindows) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Fitur Kamera tidak didukung pada Windows.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final XFile? photo = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 70,
    );
    if (photo != null) {
      setState(() {
        _selectedImage = File(photo.path);
      });
    }
  }

  void _handleSubmit() async {
    if (_titleController.text.isEmpty || _descController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Judul dan Deskripsi wajib diisi',
            style: GoogleFonts.inter(),
          ),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final user = ref.read(authNotifierProvider).user;
    if (user == null) return;

    final success = await ref.read(ticketListNotifierProvider.notifier).createTicket(
          _titleController.text,
          _descController.text,
          _selectedPriority,
          user.id,
          user.name,
          _selectedImage?.path,
        );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Tiket berhasil dibuat!', style: GoogleFonts.inter()),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final ticketState = ref.watch(ticketListNotifierProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
                        Icons.close_rounded,
                        size: 18,
                        color: isDark ? Colors.white : AppColors.textPrimary,
                      ),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const Spacer(),
                  Text(
                    'Buat Tiket',
                    style: GoogleFonts.outfit(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : AppColors.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  // Submit inline button
                  GestureDetector(
                    onTap: ticketState.isLoading ? null : _handleSubmit,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ticketState.isLoading
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              'Kirim',
                              style: GoogleFonts.outfit(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),

            // ─── Form Content ─────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title field
                    Text(
                      'Judul Keluhan',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.textDarkSecondary : AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _titleController,
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : AppColors.textPrimary,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Aplikasi tidak bisa login...',
                        hintStyle: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.textDarkSecondary.withOpacity(0.4) : AppColors.textTertiary.withOpacity(0.5),
                        ),
                        filled: false,
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ).animate().fadeIn(delay: 200.ms),

                    Container(
                      height: 1,
                      color: isDark ? AppColors.borderDark : AppColors.dividerLight,
                      margin: const EdgeInsets.symmetric(vertical: 16),
                    ),

                    // Description field
                    Text(
                      'Deskripsi Masalah',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.textDarkSecondary : AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _descController,
                      maxLines: 6,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: isDark ? Colors.white : AppColors.textPrimary,
                        height: 1.6,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Jelaskan masalah Anda secara detail...',
                        hintStyle: GoogleFonts.inter(
                          fontSize: 14,
                          color: isDark ? AppColors.textDarkSecondary.withOpacity(0.4) : AppColors.textTertiary.withOpacity(0.5),
                        ),
                        filled: true,
                        fillColor: isDark ? AppColors.surfaceElevatedDark : AppColors.surfaceElevatedLight,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ).animate().fadeIn(delay: 300.ms),

                    const SizedBox(height: 24),

                    // Priority
                    Text(
                      'PRIORITAS',
                      style: GoogleFonts.sourceCodePro(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.textDarkSecondary : AppColors.textTertiary,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        _buildPriorityChip('low', 'Rendah', AppColors.success, isDark),
                        const SizedBox(width: 8),
                        _buildPriorityChip('medium', 'Sedang', AppColors.warning, isDark),
                        const SizedBox(width: 8),
                        _buildPriorityChip('high', 'Tinggi', AppColors.error, isDark),
                      ],
                    ).animate().fadeIn(delay: 350.ms),

                    const SizedBox(height: 24),

                    // Attachment section
                    Text(
                      'LAMPIRAN',
                      style: GoogleFonts.sourceCodePro(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.textDarkSecondary : AppColors.textTertiary,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildImagePicker(isDark),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePicker(bool isDark) {
    return Column(
      children: [
        if (_selectedImage != null)
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.file(
                  _selectedImage!,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                right: 8,
                top: 8,
                child: GestureDetector(
                  onTap: () => setState(() => _selectedImage = null),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close_rounded, color: Colors.white, size: 16),
                  ),
                ),
              ),
            ],
          )
        else
          Row(
            children: [
              Expanded(
                child: _buildAttachOption(
                  icon: Icons.photo_library_outlined,
                  label: 'Galeri',
                  onTap: _pickImage,
                  isDark: isDark,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildAttachOption(
                  icon: Icons.camera_alt_outlined,
                  label: 'Kamera',
                  onTap: _takePhoto,
                  isDark: isDark,
                ),
              ),
            ],
          ),
      ],
    ).animate().fadeIn(delay: 400.ms);
  }

  Widget _buildAttachOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 28),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceElevatedDark : AppColors.surfaceElevatedLight,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? AppColors.borderDark : AppColors.borderLight.withOpacity(0.4),
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 24,
              color: isDark ? AppColors.primaryLight : AppColors.primary,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isDark ? AppColors.textDarkSecondary : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriorityChip(String value, String label, Color color, bool isDark) {
    final isSelected = _selectedPriority == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedPriority = value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? color.withOpacity(0.12)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? color : (isDark ? AppColors.borderDark : AppColors.borderLight),
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isSelected)
                  Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: Icon(Icons.check_rounded, size: 14, color: color),
                  ),
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected ? color : (isDark ? AppColors.textDarkSecondary : AppColors.textSecondary),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
