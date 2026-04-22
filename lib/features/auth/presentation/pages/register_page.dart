import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/auth_provider.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  int _currentStep = 0;

  void _handleRegister() async {
    final success = await ref.read(authNotifierProvider.notifier).register(
          _usernameController.text,
          _passwordController.text,
          _nameController.text,
        );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registrasi Berhasil! Silakan masuk.'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.of(context).pop();
    } else {
      final errorMsg = ref.read(authNotifierProvider).errorMessage;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMsg ?? 'Registrasi Gagal'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
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
                  // Step indicator
                  Row(
                    children: List.generate(3, (i) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: i <= _currentStep ? 24 : 8,
                        height: 4,
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                          color: i <= _currentStep
                              ? AppColors.primary
                              : (isDark ? AppColors.borderDark : AppColors.borderLight),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      );
                    }),
                  ),
                  const Spacer(),
                  const SizedBox(width: 48), // balance
                ],
              ),
            ),

            // ─── Form Content ─────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 32),

                    Text(
                      'Buat Akun\nBaru',
                      style: GoogleFonts.outfit(
                        fontSize: 36,
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white : AppColors.textPrimary,
                        height: 1.1,
                        letterSpacing: -1,
                      ),
                    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.15),

                    const SizedBox(height: 8),

                    Text(
                      'Isi data berikut untuk mendaftar',
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        color: isDark ? AppColors.textDarkSecondary : AppColors.textSecondary,
                      ),
                    ).animate().fadeIn(delay: 300.ms),

                    const SizedBox(height: 40),

                    // ─── Field: Nama ──────────────────
                    _buildFieldLabel('Nama Lengkap', isDark),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _nameController,
                      style: GoogleFonts.inter(fontSize: 15),
                      onChanged: (_) => _updateStep(),
                      decoration: InputDecoration(
                        hintText: 'Ody Dzakwan',
                        prefixIcon: Icon(
                          Icons.person_outline_rounded,
                          color: isDark ? AppColors.textDarkSecondary : AppColors.textTertiary,
                          size: 20,
                        ),
                      ),
                    ).animate().fadeIn(delay: 400.ms).slideX(begin: -0.06),

                    const SizedBox(height: 24),

                    // ─── Field: Username ──────────────
                    _buildFieldLabel('Username', isDark),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _usernameController,
                      style: GoogleFonts.inter(fontSize: 15),
                      onChanged: (_) => _updateStep(),
                      decoration: InputDecoration(
                        hintText: 'johndoe',
                        prefixIcon: Icon(
                          Icons.alternate_email_rounded,
                          color: isDark ? AppColors.textDarkSecondary : AppColors.textTertiary,
                          size: 20,
                        ),
                      ),
                    ).animate().fadeIn(delay: 500.ms).slideX(begin: -0.06),

                    const SizedBox(height: 24),

                    // ─── Field: Password ─────────────
                    _buildFieldLabel('Kata Sandi', isDark),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      style: GoogleFonts.inter(fontSize: 15),
                      onChanged: (_) => _updateStep(),
                      decoration: InputDecoration(
                        hintText: 'Minimal 6 karakter',
                        prefixIcon: Icon(
                          Icons.lock_outline_rounded,
                          color: isDark ? AppColors.textDarkSecondary : AppColors.textTertiary,
                          size: 20,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: isDark ? AppColors.textDarkSecondary : AppColors.textTertiary,
                            size: 20,
                          ),
                          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                        ),
                      ),
                    ).animate().fadeIn(delay: 600.ms).slideX(begin: -0.06),

                    const SizedBox(height: 12),

                    // Password strength hint
                    Row(
                      children: [
                        _buildPasswordHint(
                          'Min. 6 karakter',
                          _passwordController.text.length >= 6,
                          isDark,
                        ),
                      ],
                    ).animate().fadeIn(delay: 650.ms),

                    const SizedBox(height: 40),

                    // Submit button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: authState.isLoading ? null : _handleRegister,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: authState.isLoading
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
                                    'Buat Akun',
                                    style: GoogleFonts.outfit(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(Icons.arrow_forward_rounded, size: 20),
                                ],
                              ),
                      ),
                    ).animate().fadeIn(delay: 700.ms).scale(begin: const Offset(0.96, 0.96)),

                    const SizedBox(height: 24),

                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Sudah punya akun? ',
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
                    ).animate().fadeIn(delay: 800.ms),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _updateStep() {
    int step = 0;
    if (_nameController.text.isNotEmpty) step = 1;
    if (_usernameController.text.isNotEmpty) step = 2;
    if (step != _currentStep) {
      setState(() => _currentStep = step);
    }
  }

  Widget _buildFieldLabel(String text, bool isDark) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: isDark ? AppColors.textDarkSecondary : AppColors.textSecondary,
      ),
    );
  }

  Widget _buildPasswordHint(String text, bool valid, bool isDark) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          valid ? Icons.check_circle_rounded : Icons.circle_outlined,
          size: 14,
          color: valid ? AppColors.success : (isDark ? AppColors.textDarkSecondary : AppColors.textTertiary),
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: GoogleFonts.inter(
            fontSize: 12,
            color: valid ? AppColors.success : (isDark ? AppColors.textDarkSecondary : AppColors.textTertiary),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
