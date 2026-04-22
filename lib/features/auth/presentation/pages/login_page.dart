import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/auth_provider.dart';
import 'forgot_password_page.dart';
import 'register_page.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  void _handleLogin() async {
    final success = await ref.read(authNotifierProvider.notifier).login(
          _usernameController.text,
          _passwordController.text,
        );

    if (!mounted) return;

    if (!success) {
      final errorMsg = ref.read(authNotifierProvider).errorMessage;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMsg ?? 'Login Gagal'),
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
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: Column(
        children: [
          // ─── Top Hero Section (takes 35% height) ─────
          Expanded(
            flex: 35,
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: AppColors.heroGradient,
              ),
              child: SafeArea(
                bottom: false,
                child: Stack(
                  children: [
                    // Grid pattern
                    ...List.generate(4, (i) => Positioned(
                      left: 0,
                      right: 0,
                      top: (i + 1) * (size.height * 0.35 / 5),
                      child: Container(
                        height: 0.3,
                        color: Colors.white.withOpacity(0.04),
                      ),
                    )),
                    // Floating orb
                    Positioned(
                      right: -40,
                      top: 10,
                      child: Container(
                        width: 160,
                        height: 160,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              AppColors.primaryLight.withOpacity(0.12),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Content
                    Padding(
                      padding: const EdgeInsets.fromLTRB(28, 16, 28, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Small pill badge
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.white.withOpacity(0.08)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: const BoxDecoration(
                                    color: AppColors.primaryLight,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'E-TICKET HELPDESK',
                                  style: GoogleFonts.sourceCodePro(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primaryLight,
                                    letterSpacing: 2,
                                  ),
                                ),
                              ],
                            ),
                          ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.2),

                          const SizedBox(height: 20),

                          Text(
                            'Selamat\nDatang.',
                            style: GoogleFonts.outfit(
                              fontSize: 42,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              height: 1.05,
                              letterSpacing: -1.5,
                            ),
                          ).animate().fadeIn(delay: 300.ms).slideX(begin: -0.1),

                          const SizedBox(height: 10),

                          Text(
                            'Masuk untuk mengelola tiket bantuan Anda',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.5),
                              height: 1.4,
                            ),
                          ).animate().fadeIn(delay: 400.ms),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ─── Bottom Form Section (takes 65% height) ──
          Expanded(
            flex: 65,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(36)),
              ),
              child: Transform.translate(
                offset: const Offset(0, -36),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(28, 0, 28, 20),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(24, 36, 24, 28),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.cardDark : Colors.white,
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(
                        color: isDark ? AppColors.borderDark : AppColors.borderLight.withOpacity(0.4),
                      ),
                      boxShadow: isDark ? [] : [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 40,
                          offset: const Offset(0, 16),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Section label
                        Text(
                          'MASUK AKUN',
                          style: GoogleFonts.sourceCodePro(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                            letterSpacing: 2,
                          ),
                        ).animate().fadeIn(delay: 500.ms),
                        const SizedBox(height: 24),

                        // Username — label above field style
                        Text(
                          'Username',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: isDark ? AppColors.textDarkSecondary : AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _usernameController,
                          style: GoogleFonts.inter(fontSize: 15),
                          decoration: InputDecoration(
                            hintText: 'Masukkan username...',
                            prefixIcon: Icon(
                              Icons.alternate_email_rounded,
                              color: isDark ? AppColors.textDarkSecondary : AppColors.textTertiary,
                              size: 20,
                            ),
                          ),
                        ).animate().fadeIn(delay: 550.ms).slideY(begin: 0.1),

                        const SizedBox(height: 20),

                        // Password
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Password',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: isDark ? AppColors.textDarkSecondary : AppColors.textSecondary,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const ForgotPasswordPage()),
                              ),
                              child: Text(
                                'Lupa Password?',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.accent,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          style: GoogleFonts.inter(fontSize: 15),
                          decoration: InputDecoration(
                            hintText: '••••••••',
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
                        ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.1),

                        const SizedBox(height: 32),

                        // Login Button — full width, no gradient wrapper
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: authState.isLoading ? null : _handleLogin,
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
                                        'Masuk',
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

                        const SizedBox(height: 28),

                        // Register link — inline text style
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Belum punya akun? ',
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: isDark ? AppColors.textDarkSecondary : AppColors.textTertiary,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(builder: (_) => const RegisterPage()),
                                ),
                                child: Text(
                                  'Daftar Sekarang',
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
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
