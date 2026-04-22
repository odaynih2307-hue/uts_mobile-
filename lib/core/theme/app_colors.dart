import 'package:flutter/material.dart';

class AppColors {
  // ─── Brand Colors ───────────────────────────────────
  static const Color primary = Color(0xFF4F46E5);       // Indigo 600
  static const Color primaryDark = Color(0xFF3730A3);    // Indigo 800
  static const Color primaryLight = Color(0xFF818CF8);   // Indigo 400
  static const Color primarySoft = Color(0xFFEEF2FF);    // Indigo 50

  static const Color secondary = Color(0xFF0EA5E9);      // Sky 500
  static const Color secondaryLight = Color(0xFF7DD3FC);  // Sky 300

  // ─── Accent (Warm Amber/Gold) ───────────────────────
  static const Color accent = Color(0xFFF59E0B);         // Amber 500
  static const Color accentLight = Color(0xFFFCD34D);    // Amber 300
  static const Color accentSoft = Color(0xFFFFFBEB);     // Amber 50

  // ─── Surface & Background ──────────────────────────
  static const Color backgroundLight = Color(0xFFF8FAFC);
  static const Color backgroundDark = Color(0xFF0B1120);

  static const Color surfaceLight = Colors.white;
  static const Color surfaceDark = Color(0xFF151C2E);

  static const Color surfaceElevatedLight = Color(0xFFF1F5F9);
  static const Color surfaceElevatedDark = Color(0xFF1C2539);

  static const Color cardLight = Colors.white;
  static const Color cardDark = Color(0xFF1A2235);

  // ─── Text ──────────────────────────────────────────
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textTertiary = Color(0xFF94A3B8);
  static const Color textLight = Color(0xFFF1F5F9);
  static const Color textDarkSecondary = Color(0xFF94A3B8);

  // ─── Status Colors ─────────────────────────────────
  static const Color error = Color(0xFFEF4444);
  static const Color errorSoft = Color(0xFFFEE2E2);
  static const Color success = Color(0xFF10B981);
  static const Color successSoft = Color(0xFFD1FAE5);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningSoft = Color(0xFFFEF3C7);
  static const Color info = Color(0xFF3B82F6);
  static const Color infoSoft = Color(0xFFDBEAFE);

  // ─── Ticket Status ─────────────────────────────────
  static const Color statusPending = Color(0xFFF97316);
  static const Color statusPendingBg = Color(0xFFFFF7ED);
  static const Color statusProcess = Color(0xFF3B82F6);
  static const Color statusProcessBg = Color(0xFFEFF6FF);
  static const Color statusDone = Color(0xFF10B981);
  static const Color statusDoneBg = Color(0xFFECFDF5);
  static const Color statusCancel = Color(0xFFEF4444);
  static const Color statusCancelBg = Color(0xFFFEF2F2);

  // ─── Borders & Dividers ────────────────────────────
  static const Color borderLight = Color(0xFFE2E8F0);
  static const Color borderDark = Color(0xFF2A3348);
  static const Color dividerLight = Color(0xFFF1F5F9);
  static const Color dividerDark = Color(0xFF1E293B);

  // ─── Gradients ─────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
  );

  static const LinearGradient premiumGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF4F46E5), Color(0xFF0EA5E9)],
  );

  static const LinearGradient warmGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF59E0B), Color(0xFFF97316)],
  );

  static const LinearGradient successGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF10B981), Color(0xFF06B6D4)],
  );

  static const LinearGradient darkCardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1A2235), Color(0xFF151C2E)],
  );

  static const LinearGradient meshGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF4F46E5),
      Color(0xFF7C3AED),
      Color(0xFF0EA5E9),
    ],
    stops: [0.0, 0.5, 1.0],
  );

  // ─── Shadows ───────────────────────────────────────
  static List<BoxShadow> get softShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.04),
      blurRadius: 24,
      offset: const Offset(0, 8),
    ),
  ];

  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: primary.withOpacity(0.08),
      blurRadius: 32,
      offset: const Offset(0, 12),
    ),
  ];

  static List<BoxShadow> get elevatedShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.08),
      blurRadius: 40,
      offset: const Offset(0, 16),
    ),
  ];
}
