import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // --- Colores Principales de Salud ---
  static const Color primary = Color(0xFF0A4D68); // Azul médico profundo
  static const Color primaryLight = Color(0xFF088395); // Azul clínico fresco
  static const Color primaryCyan = Color(0xFF05BFDB); // Acento cian médico
  static const Color primarySoft = Color(0xFFEBF4F6); // Fondo suave clínico
  static const Color primary_admin = Color(0xFF1E293B); // Slate oscuro para administración

  static const Color accent = Color(0xFF00A896); // Verde azulado de salud y bienestar
  static const Color secondary = Color(0xFF0284C7);

  // --- Colores de Branding ---
  static const Color logoLightBlue = Color(0xFF088395);
  static const Color logoSoftYellow = Color(0xFFFFB703);

  // --- Colores de UI Neutros ---
  static const Color background = Color(0xFFF8FAFC); // Blanco clínico limpio
  static const Color cardBackground = Colors.white;
  static const Color textPrimary = Color(0xFF0F172A); // Texto principal oscuro
  static const Color textSecondary = Color(0xFF64748B); // Gris azulado legible
  static const Color textMuted = Color(0xFF94A3B8);
  static const Color inputBorder = Color(0xFFCBD5E1); // Gris neutro suave

  // --- Estados de Citas y Alertas ---
  static const Color statusPending = Color(0xFFF59E0B); // Ámbar / Pendiente
  static const Color statusConfirmed = Color(0xFF0284C7); // Azul cielo / Confirmada
  static const Color statusAttended = Color(0xFF10B981); // Verde esmeralda / Atendida
  static const Color statusCancelled = Color(0xFFEF4444); // Rojo suave / Cancelada
  static const Color statusRescheduled = Color(0xFF8B5CF6); // Púrpura / Reprogramada

  static const Color error = Color(0xFFDC2626);
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF0284C7);
}