import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppColors.meshGradient,
        ),
        child: Stack(
          children: [
            // Decorative floating shapes
            Positioned(
              top: -80,
              right: -60,
              child: Container(
                width: 240,
                height: 240,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.08),
                ),
              ),
            ),
            Positioned(
              bottom: -100,
              left: -80,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.05),
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.3,
              left: -40,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.white.withOpacity(0.06),
                ),
              ),
            ),

            // Center content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo container
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 40,
                          offset: const Offset(0, 16),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.support_agent_rounded,
                      size: 44,
                      color: AppColors.primary,
                    ),
                  )
                      .animate()
                      .scale(
                        begin: const Offset(0.5, 0.5),
                        end: const Offset(1, 1),
                        duration: 800.ms,
                        curve: Curves.easeOutBack,
                      )
                      .fadeIn(duration: 600.ms),

                  const SizedBox(height: 32),

                  // App name
                  Text(
                    'E-Ticket',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 400.ms, duration: 600.ms)
                      .slideY(begin: 0.3, end: 0),

                  const SizedBox(height: 4),

                  Text(
                    'Helpdesk',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: Colors.white.withOpacity(0.7),
                      letterSpacing: 4,
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 600.ms, duration: 600.ms)
                      .slideY(begin: 0.3, end: 0),

                  const SizedBox(height: 48),

                  // Loading indicator
                  SizedBox(
                    width: 28,
                    height: 28,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ).animate().fadeIn(delay: 900.ms),

                  const SizedBox(height: 16),

                  Text(
                    'Memuat...',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      color: Colors.white.withOpacity(0.5),
                      fontWeight: FontWeight.w500,
                    ),
                  ).animate().fadeIn(delay: 1000.ms),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
