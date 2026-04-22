import 'dart:ui';
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
      body: Stack(
        children: [
          // ─── Background ─────────────────────────────
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF0EA5E9),
                  Color(0xFF4F46E5),
                  Color(0xFF7C3AED),
                ],
              ),
            ),
          ),

          // Decorative shapes
          Positioned(
            top: -60,
            left: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.07),
              ),
            ),
          ),
          Positioned(
            bottom: -40,
            right: -30,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),

          // ─── Content ────────────────────────────────
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 16),
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
                      child: _isSent ? _buildSuccessState() : _buildFormState(isDark),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.mark_email_read_rounded,
            size: 44,
            color: Colors.white,
          ),
        ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack).fadeIn(),

        const SizedBox(height: 28),

        Text(
          'Email Terkirim!',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2),

        const SizedBox(height: 12),

        Text(
          'Instruksi pengaturan ulang kata sandi telah dikirim ke email Anda. Periksa kotak masuk atau folder spam.',
          textAlign: TextAlign.center,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            color: Colors.white.withOpacity(0.65),
            height: 1.6,
          ),
        ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2),

        const SizedBox(height: 36),

        OutlinedButton.icon(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_rounded, size: 18),
          label: Text(
            'Kembali ke Login',
            style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
          ),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.white,
            side: BorderSide(color: Colors.white.withOpacity(0.4)),
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
        ).animate().fadeIn(delay: 500.ms),
      ],
    );
  }

  Widget _buildFormState(bool isDark) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Icon
        Container(
          width: 68,
          height: 68,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: const Icon(Icons.lock_reset_rounded, size: 32, color: AppColors.primary),
        ).animate().scale(duration: 500.ms, curve: Curves.easeOutBack).fadeIn(),

        const SizedBox(height: 24),

        Text(
          'Lupa Kata Sandi?',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),

        const SizedBox(height: 8),

        Text(
          'Masukkan email atau username Anda\nuntuk memulihkan akun',
          textAlign: TextAlign.center,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            color: Colors.white.withOpacity(0.6),
            height: 1.5,
          ),
        ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2),

        const SizedBox(height: 36),

        // Form Card
        ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: (isDark ? Colors.black : Colors.white)
                    .withOpacity(isDark ? 0.3 : 0.88),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: Colors.white.withOpacity(isDark ? 0.08 : 0.25),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _emailController,
                    style: GoogleFonts.plusJakartaSans(fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'Email / Username',
                      prefixIcon: Icon(
                        Icons.email_outlined,
                        color: isDark ? AppColors.textDarkSecondary : AppColors.textTertiary,
                        size: 20,
                      ),
                    ),
                  ).animate().fadeIn(delay: 400.ms).slideX(begin: -0.05),

                  const SizedBox(height: 24),

                  Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF0EA5E9), Color(0xFF4F46E5)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF0EA5E9).withOpacity(0.35),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleReset,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        minimumSize: const Size(double.infinity, 56),
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
                          : Text(
                              'Kirim Instruksi',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ).animate().fadeIn(delay: 500.ms).scale(begin: const Offset(0.95, 0.95)),
                ],
              ),
            ),
          ),
        ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.08),

        const SizedBox(height: 28),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Ingat kata sandi? ',
              style: GoogleFonts.plusJakartaSans(
                color: Colors.white.withOpacity(0.65),
                fontSize: 13,
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Text(
                'Masuk',
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.white,
                ),
              ),
            ),
          ],
        ).animate().fadeIn(delay: 600.ms),

        const SizedBox(height: 20),
      ],
    );
  }
}
