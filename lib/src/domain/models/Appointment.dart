import 'package:flutter/material.dart';
import 'package:myfirstlove/src/constants/app_colors.dart';

enum AppointmentStatus {
  PENDIENTE,
  CONFIRMADA,
  ATENDIDA,
  CANCELADA,
  REPROGRAMADA;

  static AppointmentStatus fromString(String? status) {
    switch (status?.toUpperCase()) {
      case 'CONFIRMADA':
        return AppointmentStatus.CONFIRMADA;
      case 'ATENDIDA':
        return AppointmentStatus.ATENDIDA;
      case 'CANCELADA':
        return AppointmentStatus.CANCELADA;
      case 'REPROGRAMADA':
        return AppointmentStatus.REPROGRAMADA;
      case 'PENDIENTE':
      default:
        return AppointmentStatus.PENDIENTE;
    }
  }

  String get displayName {
    switch (this) {
      case AppointmentStatus.PENDIENTE:
        return 'Pendiente';
      case AppointmentStatus.CONFIRMADA:
        return 'Confirmada';
      case AppointmentStatus.ATENDIDA:
        return 'Atendida';
      case AppointmentStatus.CANCELADA:
        return 'Cancelada';
      case AppointmentStatus.REPROGRAMADA:
        return 'Reprogramada';
    }
  }

  Color get color {
    switch (this) {
      case AppointmentStatus.PENDIENTE:
        return AppColors.statusPending;
      case AppointmentStatus.CONFIRMADA:
        return AppColors.statusConfirmed;
      case AppointmentStatus.ATENDIDA:
        return AppColors.statusAttended;
      case AppointmentStatus.CANCELADA:
        return AppColors.statusCancelled;
      case AppointmentStatus.REPROGRAMADA:
        return AppColors.statusRescheduled;
    }
  }

  IconData get icon {
    switch (this) {
      case AppointmentStatus.PENDIENTE:
        return Icons.access_time;
      case AppointmentStatus.CONFIRMADA:
        return Icons.check_circle_outline;
      case AppointmentStatus.ATENDIDA:
        return Icons.verified;
      case AppointmentStatus.CANCELADA:
        return Icons.cancel_outlined;
      case AppointmentStatus.REPROGRAMADA:
        return Icons.event_repeat;
    }
  }
}

class Appointment {
  final String id;
  final String patientId;
  final String patientName;
  final String patientPhone;
  final String doctorId;
  final String doctorName;
  final String doctorSpecialty;
  final String doctorImage;
  final DateTime appointmentDate;
  final String appointmentTime;
  final AppointmentStatus status;
  final String reason;
  final double consultationFee;
  final String? diagnosis;
  final String? treatment;
  final String? notes;
  final DateTime createdAt;

  Appointment({
    required this.id,
    required this.patientId,
    required this.patientName,
    required this.patientPhone,
    required this.doctorId,
    required this.doctorName,
    required this.doctorSpecialty,
    required this.doctorImage,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.status,
    required this.reason,
    required this.consultationFee,
    this.diagnosis,
    this.treatment,
    this.notes,
    required this.createdAt,
  });

  Appointment copyWith({
    String? id,
    String? patientId,
    String? patientName,
    String? patientPhone,
    String? doctorId,
    String? doctorName,
    String? doctorSpecialty,
    String? doctorImage,
    DateTime? appointmentDate,
    String? appointmentTime,
    AppointmentStatus? status,
    String? reason,
    double? consultationFee,
    String? diagnosis,
    String? treatment,
    String? notes,
    DateTime? createdAt,
  }) {
    return Appointment(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      patientName: patientName ?? this.patientName,
      patientPhone: patientPhone ?? this.patientPhone,
      doctorId: doctorId ?? this.doctorId,
      doctorName: doctorName ?? this.doctorName,
      doctorSpecialty: doctorSpecialty ?? this.doctorSpecialty,
      doctorImage: doctorImage ?? this.doctorImage,
      appointmentDate: appointmentDate ?? this.appointmentDate,
      appointmentTime: appointmentTime ?? this.appointmentTime,
      status: status ?? this.status,
      reason: reason ?? this.reason,
      consultationFee: consultationFee ?? this.consultationFee,
      diagnosis: diagnosis ?? this.diagnosis,
      treatment: treatment ?? this.treatment,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory Appointment.fromJson(Map<String, dynamic> json) => Appointment(
        id: json["id"]?.toString() ?? '',
        patientId: json["patient_id"]?.toString() ?? '',
        patientName: json["patient_name"] ?? '',
        patientPhone: json["patient_phone"] ?? '',
        doctorId: json["doctor_id"]?.toString() ?? '',
        doctorName: json["doctor_name"] ?? '',
        doctorSpecialty: json["doctor_specialty"] ?? '',
        doctorImage: json["doctor_image"] ?? '',
        appointmentDate: json["appointment_date"] != null
            ? DateTime.parse(json["appointment_date"].toString())
            : DateTime.now(),
        appointmentTime: json["appointment_time"] ?? '',
        status: AppointmentStatus.fromString(json["status"]),
        reason: json["reason"] ?? '',
        consultationFee: json["consultation_fee"] != null
            ? (json["consultation_fee"] as num).toDouble()
            : 80.0,
        diagnosis: json["diagnosis"],
        treatment: json["treatment"],
        notes: json["notes"],
        createdAt: json["created_at"] != null
            ? DateTime.parse(json["created_at"].toString())
            : DateTime.now(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "patient_id": patientId,
        "patient_name": patientName,
        "patient_phone": patientPhone,
        "doctor_id": doctorId,
        "doctor_name": doctorName,
        "doctor_specialty": doctorSpecialty,
        "doctor_image": doctorImage,
        "appointment_date": appointmentDate.toIso8601String(),
        "appointment_time": appointmentTime,
        "status": status.name,
        "reason": reason,
        "consultation_fee": consultationFee,
        "diagnosis": diagnosis,
        "treatment": treatment,
        "notes": notes,
        "created_at": createdAt.toIso8601String(),
      };
}
