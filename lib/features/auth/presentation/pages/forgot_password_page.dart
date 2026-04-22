import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();
  bool _isLoading = false;
  bool _isSent = false;

  void _handleReset() async {
    if (_emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan masukkan email atau username Anda'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isLoading = false;
        _isSent = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
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
                ],
              ),
            ),

            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    switchInCurve: Curves.easeOutCubic,
                    switchOutCurve: Curves.easeInCubic,
                    child: _isSent
                        ? _buildSuccessState(isDark)
                        : _buildFormState(isDark),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessState(bool isDark) {
    return Column(
      key: const ValueKey('success'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Large icon with background
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.success.withOpacity(isDark ? 0.1 : 0.08),
            borderRadius: BorderRadius.circular(24),
          ),
          child: const Icon(
            Icons.mark_email_read_rounded,
            size: 36,
            color: AppColors.success,
          ),
        ).animate().scale(duration: 500.ms, curve: Curves.easeOutBack),

        const SizedBox(height: 28),

        Text(
          'Email Terkirim!',
          style: GoogleFonts.outfit(
            fontSize: 32,
            fontWeight: FontWeight.w800,
            color: isDark ? Colors.white : AppColors.textPrimary,
            letterSpacing: -1,
          ),
        ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.15),

        const SizedBox(height: 10),

        Text(
          'Instruksi pengaturan ulang kata sandi telah dikirim ke email Anda. Periksa kotak masuk atau folder spam.',
          style: GoogleFonts.inter(
            fontSize: 15,
            color: isDark ? AppColors.textDarkSecondary : AppColors.textSecondary,
            height: 1.6,
          ),
        ).animate().fadeIn(delay: 300.ms),

        const SizedBox(height: 36),

        // Inline button
        SizedBox(
          width: double.infinity,
          height: 56,
          child: OutlinedButton.icon(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_rounded, size: 18),
            label: Text(
              'Kembali ke Login',
              style: GoogleFonts.outfit(fontWeight: FontWeight.w600, fontSize: 15),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: BorderSide(color: isDark ? AppColors.borderDark : AppColors.primary.withOpacity(0.2)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
          ),
        ).animate().fadeIn(delay: 400.ms),
      ],
    );
  }

  Widget _buildFormState(bool isDark) {
    return Column(
      key: const ValueKey('form'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Large icon
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(isDark ? 0.1 : 0.06),
            borderRadius: BorderRadius.circular(22),
          ),
          child: const Icon(
            Icons.lock_reset_rounded,
            size: 32,
            color: AppColors.primary,
          ),
        ).animate().fadeIn(delay: 200.ms).scale(duration: 400.ms, curve: Curves.easeOutBack),

        const SizedBox(height: 28),

        Text(
          'Lupa Kata\nSandi?',
          style: GoogleFonts.outfit(
            fontSize: 36,
            fontWeight: FontWeight.w800,
            color: isDark ? Colors.white : AppColors.textPrimary,
            height: 1.1,
            letterSpacing: -1,
          ),
        ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.15),

        const SizedBox(height: 10),

        Text(
          'Masukkan email atau username Anda untuk menerima instruksi pemulihan akun.',
          style: GoogleFonts.inter(
            fontSize: 15,
            color: isDark ? AppColors.textDarkSecondary : AppColors.textSecondary,
            height: 1.5,
          ),
        ).animate().fadeIn(delay: 400.ms),

        const SizedBox(height: 36),

        Text(
          'Email / Username',
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.textDarkSecondary : AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _emailController,
          style: GoogleFonts.inter(fontSize: 15),
          decoration: InputDecoration(
            hintText: 'Masukkan email atau username...',
            prefixIcon: Icon(
              Icons.email_outlined,
              color: isDark ? AppColors.textDarkSecondary : AppColors.textTertiary,
              size: 20,
            ),
          ),
        ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.1),

        const SizedBox(height: 32),

        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _handleReset,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: _isLoading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Kirim Instruksi',
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.send_rounded, size: 18),
                    ],
                  ),
          ),
        ).animate().fadeIn(delay: 600.ms).scale(begin: const Offset(0.96, 0.96)),

        const SizedBox(height: 24),

        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Ingat kata sandi? ',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: isDark ? AppColors.textDarkSecondary : AppColors.textTertiary,
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Text(
                  'Masuk',
                  style: GoogleFonts.outfit(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ).animate().fadeIn(delay: 700.ms),

        const SizedBox(height: 20),
      ],
    );
  }
}
