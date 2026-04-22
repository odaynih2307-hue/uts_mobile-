import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Centralized text style helpers for consistent typography.
class AppTextStyles {
  // ─── Display ───────────────────────────────────────
  static TextStyle displayLarge({Color? color}) => GoogleFonts.plusJakartaSans(
    fontSize: 32,
    fontWeight: FontWeight.w800,
    color: color ?? AppColors.textPrimary,
    height: 1.2,
    letterSpacing: -0.5,
  );

  static TextStyle displayMedium({Color? color}) => GoogleFonts.plusJakartaSans(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: color ?? AppColors.textPrimary,
    height: 1.2,
    letterSpacing: -0.3,
  );

  // ─── Headings ──────────────────────────────────────
  static TextStyle h1({Color? color}) => GoogleFonts.plusJakartaSans(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: color ?? AppColors.textPrimary,
    height: 1.3,
  );

  static TextStyle h2({Color? color}) => GoogleFonts.plusJakartaSans(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: color ?? AppColors.textPrimary,
    height: 1.3,
  );

  static TextStyle h3({Color? color}) => GoogleFonts.plusJakartaSans(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: color ?? AppColors.textPrimary,
    height: 1.4,
  );

  // ─── Body ──────────────────────────────────────────
  static TextStyle bodyLarge({Color? color}) => GoogleFonts.plusJakartaSans(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: color ?? AppColors.textPrimary,
    height: 1.5,
  );

  static TextStyle body({Color? color}) => GoogleFonts.plusJakartaSans(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: color ?? AppColors.textPrimary,
    height: 1.5,
  );

  static TextStyle bodySmall({Color? color}) => GoogleFonts.plusJakartaSans(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: color ?? AppColors.textSecondary,
    height: 1.5,
  );

  // ─── Labels ────────────────────────────────────────
  static TextStyle label({Color? color}) => GoogleFonts.plusJakartaSans(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: color ?? AppColors.textPrimary,
  );

  static TextStyle labelSmall({Color? color}) => GoogleFonts.plusJakartaSans(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: color ?? AppColors.textSecondary,
    letterSpacing: 0.5,
  );

  // ─── Caption & Overline ────────────────────────────
  static TextStyle caption({Color? color}) => GoogleFonts.plusJakartaSans(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: color ?? AppColors.textTertiary,
  );

  static TextStyle overline({Color? color}) => GoogleFonts.plusJakartaSans(
    fontSize: 10,
    fontWeight: FontWeight.w700,
    color: color ?? AppColors.textTertiary,
    letterSpacing: 1.5,
  );

  // ─── Button ────────────────────────────────────────
  static TextStyle button({Color? color}) => GoogleFonts.plusJakartaSans(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: color ?? Colors.white,
  );

  // ─── Monospace (for IDs, codes) ────────────────────
  static TextStyle mono({Color? color}) => GoogleFonts.jetBrainsMono(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: color ?? AppColors.textTertiary,
  );
}
