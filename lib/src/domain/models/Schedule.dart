class DoctorSchedule {
  final String id;
  final String doctorId;
  final int dayOfWeek; // 1 = Lunes, 7 = Domingo
  final String dayName;
  final String morningShift;
  final String afternoonShift;
  final List<String> defaultSlots;
  final bool isActive;

  DoctorSchedule({
    required this.id,
    required this.doctorId,
    required this.dayOfWeek,
    required this.dayName,
    this.morningShift = "08:00 - 13:00",
    this.afternoonShift = "15:00 - 18:00",
    required this.defaultSlots,
    this.isActive = true,
  });

  DoctorSchedule copyWith({
    String? id,
    String? doctorId,
    int? dayOfWeek,
    String? dayName,
    String? morningShift,
    String? afternoonShift,
    List<String>? defaultSlots,
    bool? isActive,
  }) {
    return DoctorSchedule(
      id: id ?? this.id,
      doctorId: doctorId ?? this.doctorId,
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
      dayName: dayName ?? this.dayName,
      morningShift: morningShift ?? this.morningShift,
      afternoonShift: afternoonShift ?? this.afternoonShift,
      defaultSlots: defaultSlots ?? this.defaultSlots,
      isActive: isActive ?? this.isActive,
    );
  }

  factory DoctorSchedule.fromJson(Map<String, dynamic> json) => DoctorSchedule(
        id: json["id"]?.toString() ?? '',
        doctorId: json["doctor_id"]?.toString() ?? '',
        dayOfWeek: json["day_of_week"] is int
            ? json["day_of_week"]
            : int.tryParse(json["day_of_week"].toString()) ?? 1,
        dayName: json["day_name"] ?? '',
        morningShift: json["morning_shift"] ?? "08:00 - 13:00",
        afternoonShift: json["afternoon_shift"] ?? "15:00 - 18:00",
        defaultSlots: json["default_slots"] != null
            ? List<String>.from(json["default_slots"])
            : ["08:00 AM", "08:30 AM", "09:00 AM", "09:30 AM", "10:00 AM", "10:30 AM", "11:00 AM", "11:30 AM", "03:00 PM", "03:30 PM", "04:00 PM", "04:30 PM"],
        isActive: json["is_active"] ?? true,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "doctor_id": doctorId,
        "day_of_week": dayOfWeek,
        "day_name": dayName,
        "morning_shift": morningShift,
        "afternoon_shift": afternoonShift,
        "default_slots": defaultSlots,
        "is_active": isActive,
      };
}
