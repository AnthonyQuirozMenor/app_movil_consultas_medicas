class MedicalHistory {
  final String id;
  final String appointmentId;
  final String patientId;
  final String patientName;
  final String doctorId;
  final String doctorName;
  final String specialty;
  final DateTime date;
  final String reason;
  final String diagnosis;
  final String treatment;
  final String observations;

  MedicalHistory({
    required this.id,
    required this.appointmentId,
    required this.patientId,
    required this.patientName,
    required this.doctorId,
    required this.doctorName,
    required this.specialty,
    required this.date,
    required this.reason,
    required this.diagnosis,
    required this.treatment,
    required this.observations,
  });

  factory MedicalHistory.fromJson(Map<String, dynamic> json) => MedicalHistory(
        id: json["id"]?.toString() ?? '',
        appointmentId: json["appointment_id"]?.toString() ?? '',
        patientId: json["patient_id"]?.toString() ?? '',
        patientName: json["patient_name"] ?? '',
        doctorId: json["doctor_id"]?.toString() ?? '',
        doctorName: json["doctor_name"] ?? '',
        specialty: json["specialty"] ?? '',
        date: json["date"] != null
            ? DateTime.parse(json["date"].toString())
            : DateTime.now(),
        reason: json["reason"] ?? '',
        diagnosis: json["diagnosis"] ?? '',
        treatment: json["treatment"] ?? '',
        observations: json["observations"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "appointment_id": appointmentId,
        "patient_id": patientId,
        "patient_name": patientName,
        "doctor_id": doctorId,
        "doctor_name": doctorName,
        "specialty": specialty,
        "date": date.toIso8601String(),
        "reason": reason,
        "diagnosis": diagnosis,
        "treatment": treatment,
        "observations": observations,
      };
}
