import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0D12),
      body: Stack(
        children: [
          // Subtle grid lines
          ...List.generate(6, (i) => Positioned(
            left: 0, right: 0,
            top: size.height * (i / 6),
            child: Container(height: 0.3, color: Colors.white.withOpacity(0.03)),
          )),
          ...List.generate(4, (i) => Positioned(
            top: 0, bottom: 0,
            left: size.width * ((i + 1) / 5),
            child: Container(width: 0.3, color: Colors.white.withOpacity(0.03)),
          )),

          // Glow
          Positioned(
            top: size.height * 0.2,
            left: size.width * 0.3,
            child: Container(
              width: 200, height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  AppColors.primary.withOpacity(0.08),
                  Colors.transparent,
                ]),
              ),
            ),
          ),

          // Content — left-aligned, bottom-heavy
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(flex: 3),

                  // Logo mark
                  Container(
                    width: 56, height: 56,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: AppColors.primary,
                    ),
                    child: const Icon(Icons.support_agent_rounded, size: 28, color: Colors.white),
                  ).animate()
                      .scale(begin: const Offset(0, 0), duration: 600.ms, curve: Curves.easeOutBack)
                      .fadeIn(),

                  const SizedBox(height: 28),

                  Text(
                    'E-Ticket',
                    style: GoogleFonts.outfit(
                      fontSize: 44, fontWeight: FontWeight.w800,
                      color: Colors.white, letterSpacing: -2, height: 1,
                    ),
                  ).animate().fadeIn(delay: 300.ms).slideX(begin: -0.15),

                  Text(
                    'Helpdesk',
                    style: GoogleFonts.outfit(
                      fontSize: 44, fontWeight: FontWeight.w800,
                      color: AppColors.primaryLight, letterSpacing: -2, height: 1.1,
                    ),
                  ).animate().fadeIn(delay: 400.ms).slideX(begin: -0.15),

                  const SizedBox(height: 16),

                  Container(
                    width: 40, height: 3,
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ).animate().fadeIn(delay: 600.ms).slideX(begin: -0.3),

                  const SizedBox(height: 16),

                  Text(
                    'Sistem manajemen tiket\nbantuan yang cerdas.',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      color: Colors.white.withOpacity(0.35),
                      height: 1.5,
                    ),
                  ).animate().fadeIn(delay: 700.ms),

                  const Spacer(flex: 2),

                  // Loading
                  Row(
                    children: [
                      SizedBox(
                        width: 16, height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.primaryLight.withOpacity(0.5),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Memuat...',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.25),
                        ),
                      ),
                    ],
                  ).animate().fadeIn(delay: 900.ms),

                  const SizedBox(height: 48),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
