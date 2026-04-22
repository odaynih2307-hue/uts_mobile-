import 'package:flutter/material.dart';

class AppColors {
  // ─── Brand Colors ───────────────────────────────────
  static const Color primary = Color(0xFF0D9488);       // Teal 600
  static const Color primaryDark = Color(0xFF0F766E);    // Teal 700
  static const Color primaryLight = Color(0xFF5EEAD4);   // Teal 300
  static const Color primarySoft = Color(0xFFF0FDFA);    // Teal 50

  static const Color secondary = Color(0xFFE11D48);      // Rose 600
  static const Color secondaryLight = Color(0xFFFDA4AF);  // Rose 300

  // ─── Accent (Rose Gold) ───────────────────────────
  static const Color accent = Color(0xFFD4A373);         // Rose Gold
  static const Color accentLight = Color(0xFFF5DEB3);    // Wheat
  static const Color accentSoft = Color(0xFFFFF8F0);     // Cream

  // ─── Surface & Background ──────────────────────────
  static const Color backgroundLight = Color(0xFFF5F5F0);
  static const Color backgroundDark = Color(0xFF0C0F14);

  static const Color surfaceLight = Color(0xFFFAFAF8);
  static const Color surfaceDark = Color(0xFF141820);

  static const Color surfaceElevatedLight = Color(0xFFEEEDE8);
  static const Color surfaceElevatedDark = Color(0xFF1C2028);

  static const Color cardLight = Color(0xFFFFFFFD);
  static const Color cardDark = Color(0xFF191D25);

  // ─── Text ──────────────────────────────────────────
  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textTertiary = Color(0xFF9CA3AF);
  static const Color textLight = Color(0xFFF3F4F6);
  static const Color textDarkSecondary = Color(0xFF9CA3AF);

  // ─── Status Colors ─────────────────────────────────
  static const Color error = Color(0xFFE11D48);
  static const Color errorSoft = Color(0xFFFFF1F2);
  static const Color success = Color(0xFF059669);
  static const Color successSoft = Color(0xFFD1FAE5);
  static const Color warning = Color(0xFFD97706);
  static const Color warningSoft = Color(0xFFFEF3C7);
  static const Color info = Color(0xFF0891B2);
  static const Color infoSoft = Color(0xFFCFFAFE);

  // ─── Ticket Status ─────────────────────────────────
  static const Color statusPending = Color(0xFFD97706);
  static const Color statusPendingBg = Color(0xFFFFFBEB);
  static const Color statusProcess = Color(0xFF0891B2);
  static const Color statusProcessBg = Color(0xFFECFEFF);
  static const Color statusDone = Color(0xFF059669);
  static const Color statusDoneBg = Color(0xFFECFDF5);
  static const Color statusCancel = Color(0xFFE11D48);
  static const Color statusCancelBg = Color(0xFFFFF1F2);

  // ─── Borders & Dividers ────────────────────────────
  static const Color borderLight = Color(0xFFE5E5DC);
  static const Color borderDark = Color(0xFF2A2E38);
  static const Color dividerLight = Color(0xFFF0F0EB);
  static const Color dividerDark = Color(0xFF22262E);

  // ─── Gradients ─────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0D9488), Color(0xFF059669)],
  );

  static const LinearGradient premiumGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0D9488), Color(0xFF0891B2)],
  );

  static const LinearGradient warmGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFD4A373), Color(0xFFD97706)],
  );

  static const LinearGradient successGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF059669), Color(0xFF0D9488)],
  );

  static const LinearGradient darkCardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF191D25), Color(0xFF141820)],
  );

  static const LinearGradient meshGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF0C0F14),
      Color(0xFF0D9488),
      Color(0xFF059669),
    ],
    stops: [0.0, 0.5, 1.0],
  );

  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF0D9488),
      Color(0xFF134E4A),
      Color(0xFF0C0F14),
    ],
    stops: [0.0, 0.6, 1.0],
  );

  static const LinearGradient roseGoldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFD4A373), Color(0xFFE11D48)],
  );

  // ─── Shadows ───────────────────────────────────────
  static List<BoxShadow> get softShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.03),
      blurRadius: 20,
      offset: const Offset(0, 6),
    ),
  ];

  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: primary.withOpacity(0.06),
      blurRadius: 28,
      offset: const Offset(0, 10),
    ),
  ];

  static List<BoxShadow> get elevatedShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.06),
      blurRadius: 36,
      offset: const Offset(0, 14),
    ),
  ];

  static List<BoxShadow> get glowShadow => [
    BoxShadow(
      color: primary.withOpacity(0.3),
      blurRadius: 24,
      offset: const Offset(0, 8),
    ),
  ];
}
