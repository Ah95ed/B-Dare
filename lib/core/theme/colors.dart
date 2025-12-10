import 'package:flutter/material.dart';

/// نظام ألوان منظم لتطبيق Mystery Link
/// 
/// الألوان منظمة حسب الاستخدام:
/// - Primary/Secondary/Accent: ألوان العلامة التجارية
/// - Status: ألوان الحالة (نجاح، خطأ، تحذير، معلومات)
/// - Neutral: ألوان الخلفية والنصوص
/// - Game: ألوان خاصة باللعبة (بطاقات، روابط)
class AppColors {
  // ============================================
  // Primary Brand Colors (ألوان العلامة التجارية الأساسية)
  // ============================================
  /// اللون الأساسي للتطبيق (Indigo)
  static const Color primary = Color(0xFF6366F1);
  static const Color primaryDark = Color(0xFF4F46E5);
  static const Color primaryLight = Color(0xFF818CF8);
  
  // ============================================
  // Secondary Brand Colors (ألوان ثانوية)
  // ============================================
  /// اللون الثانوي (أخضر)
  static const Color secondary = Color(0xFF10B981);
  static const Color secondaryDark = Color(0xFF059669);
  static const Color secondaryLight = Color(0xFF34D399);
  
  // ============================================
  // Accent Colors (ألوان مميزة)
  // ============================================
  /// اللون المميز (برتقالي/ذهبي)
  static const Color accent = Color(0xFFF59E0B);
  static const Color accentDark = Color(0xFFD97706);
  
  // ============================================
  // Status Colors (ألوان الحالة)
  // ============================================
  /// نجاح / إجابة صحيحة
  static const Color success = Color(0xFF10B981);
  /// خطأ / إجابة خاطئة
  static const Color error = Color(0xFFEF4444);
  /// تحذير / وقت منخفض
  static const Color warning = Color(0xFFF59E0B);
  /// معلومات / إرشادات
  static const Color info = Color(0xFF3B82F6);
  
  // ============================================
  // Neutral Colors (ألوان محايدة)
  // ============================================
  /// خلفية الوضع الفاتح
  static const Color background = Color(0xFFF9FAFB);
  /// خلفية الوضع الداكن
  static const Color backgroundDark = Color(0xFF111827);
  /// سطح الوضع الفاتح (بطاقات، حاويات)
  static const Color surface = Color(0xFFFFFFFF);
  /// سطح الوضع الداكن
  static const Color surfaceDark = Color(0xFF1F2937);
  /// نص رئيسي (وضع فاتح)
  static const Color textPrimary = Color(0xFF111827);
  /// نص ثانوي / نص باهت
  static const Color textSecondary = Color(0xFF6B7280);
  /// نص رئيسي (وضع داكن)
  static const Color textDark = Color(0xFFF9FAFB);
  
  // ============================================
  // Game-Specific Colors (ألوان خاصة باللعبة)
  // ============================================
  /// لون بطاقة البداية (A) - بنفسجي
  static const Color cardStart = Color(0xFF8B5CF6);
  /// لون بطاقة النهاية (Z) - وردي
  static const Color cardEnd = Color(0xFFEC4899);
  /// لون الروابط الوسيطة المختارة
  static const Color cardLink = Color(0xFF6366F1);
  
  // ============================================
  // Game Mode Colors (ألوان أنماط اللعب)
  // ============================================
  /// لون وضع Solo - بنفسجي واضح
  static const Color modeSolo = Color(0xFF6366F1);
  /// لون وضع Group - أخضر واضح
  static const Color modeGroup = Color(0xFF10B981);
  /// لون وضع Practice - برتقالي/ذهبي واضح
  static const Color modePractice = Color(0xFFF59E0B);
  /// لون الوضع الموجّه - أزرق واضح
  static const Color modeGuided = Color(0xFF3B82F6);
  /// لون التحدي اليومي - بنفسجي وردي
  static const Color modeDaily = Color(0xFF8B5CF6);
  
  // ============================================
  // Helper Methods (طرق مساعدة)
  // ============================================
  /// الحصول على لون حسب حالة الإجابة
  static Color getAnswerColor(bool isCorrect) {
    return isCorrect ? success : error;
  }
  
  /// الحصول على لون حسب حالة الوقت
  static Color getTimeColor(int remainingSeconds, int totalSeconds) {
    final ratio = remainingSeconds / totalSeconds;
    if (ratio <= 0.2) return error;      // أقل من 20% - أحمر
    if (ratio <= 0.5) return warning;   // أقل من 50% - برتقالي
    return primary;                      // عادي - أزرق
  }
  
  /// الحصول على لون حسب نمط اللعب
  static Color getModeColor(String gameMode) {
    switch (gameMode.toLowerCase()) {
      case 'solo':
        return modeSolo;
      case 'group':
        return modeGroup;
      case 'practice':
        return modePractice;
      case 'guided':
        return modeGuided;
      case 'daily':
        return modeDaily;
      default:
        return primary;
    }
  }
}

