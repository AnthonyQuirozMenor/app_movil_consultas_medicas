import 'package:myfirstlove/src/domain/models/Appointment.dart';
import 'package:myfirstlove/src/domain/models/Doctor.dart';
import 'package:myfirstlove/src/domain/models/MedicalHistory.dart';
import 'package:myfirstlove/src/domain/models/Schedule.dart';
import 'package:myfirstlove/src/domain/models/Specialty.dart';

class MedicalLocalStore {
  // Singleton para persistencia en memoria durante la sesión
  static final MedicalLocalStore _instance = MedicalLocalStore._internal();
  factory MedicalLocalStore() => _instance;

  MedicalLocalStore._internal() {
    _initData();
  }

  late List<Specialty> _specialties;
  late List<Doctor> _doctors;
  late List<DoctorSchedule> _schedules;
  late List<Appointment> _appointments;
  late List<MedicalHistory> _history;

  void _initData() {
    _specialties = [
      Specialty(
        id: '1',
        name: 'Medicina General',
        description: 'Atención primaria integral, chequeos preventivos y diagnóstico general.',
        icon: 'medical_services',
        basePrice: 60.0,
        doctorsCount: 3,
      ),
      Specialty(
        id: '2',
        name: 'Pediatría',
        description: 'Cuidado especializado en salud infantil, crecimiento y desarrollo.',
        icon: 'child_care',
        basePrice: 80.0,
        doctorsCount: 2,
      ),
      Specialty(
        id: '3',
        name: 'Cardiología',
        description: 'Prevención, diagnóstico y tratamiento de enfermedades cardiovasculares.',
        icon: 'favorite',
        basePrice: 120.0,
        doctorsCount: 2,
      ),
      Specialty(
        id: '4',
        name: 'Dermatología',
        description: 'Diagnóstico y tratamiento de patologías de la piel, cabello y uñas.',
        icon: 'spa',
        basePrice: 90.0,
        doctorsCount: 2,
      ),
      Specialty(
        id: '5',
        name: 'Ginecología',
        description: 'Salud integral de la mujer, control prenatal y salud reproductiva.',
        icon: 'pregnant_woman',
        basePrice: 100.0,
        doctorsCount: 2,
      ),
      Specialty(
        id: '6',
        name: 'Traumatología',
        description: 'Lesiones óseas, articulares, fracturas y rehabilitación musculoesquelética.',
        icon: 'healing',
        basePrice: 100.0,
        doctorsCount: 1,
      ),
      Specialty(
        id: '7',
        name: 'Oftalmología',
        description: 'Exámenes de agudeza visual, patologías oculares y salud ocular.',
        icon: 'visibility',
        basePrice: 85.0,
        doctorsCount: 1,
      ),
      Specialty(
        id: '8',
        name: 'Neurología',
        description: 'Trastornos del sistema nervioso central y periférico, cefaleas y migrañas.',
        icon: 'psychology',
        basePrice: 130.0,
        doctorsCount: 1,
      ),
      Specialty(
        id: '9',
        name: 'Odontología',
        description: 'Salud bucal, profilaxis, odontología restauradora y estética.',
        icon: 'sentiment_very_satisfied',
        basePrice: 75.0,
        doctorsCount: 1,
      ),
      Specialty(
        id: '10',
        name: 'Psicología',
        description: 'Apoyo terapéutico emocional, manejo del estrés y bienestar mental.',
        icon: 'self_improvement',
        basePrice: 80.0,
        doctorsCount: 1,
      ),
    ];

    _doctors = [
      Doctor(
        id: 'doc_1',
        userId: 2,
        name: 'Carlos',
        lastname: 'Mendoza',
        cmp: 'CMP-45892',
        specialtyId: '2',
        specialtyName: 'Pediatría',
        email: 'dr.mendoza@mediapp.com',
        phone: '+51 987 654 321',
        description: 'Especialista en pediatría y desarrollo infantil con más de 8 años de experiencia en hospitales y clínicas.',
        experienceYears: 8,
        consultationFee: 80.0,
        image: 'https://images.unsplash.com/photo-1622253692010-333f2da6031d?w=400&q=80',
        rating: 4.9,
        reviewsCount: 42,
      ),
      Doctor(
        id: 'doc_2',
        userId: 3,
        name: 'Ana',
        lastname: 'Torres',
        cmp: 'CMP-51204',
        specialtyId: '1',
        specialtyName: 'Medicina General',
        email: 'dra.torres@mediapp.com',
        phone: '+51 984 123 456',
        description: 'Médico cirujano con enfoque en medicina preventiva y atención integral familiar.',
        experienceYears: 6,
        consultationFee: 60.0,
        image: 'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?w=400&q=80',
        rating: 4.8,
        reviewsCount: 35,
      ),
      Doctor(
        id: 'doc_3',
        name: 'Roberto',
        lastname: 'Vásquez',
        cmp: 'CMP-39871',
        specialtyId: '3',
        specialtyName: 'Cardiología',
        email: 'dr.vasquez@mediapp.com',
        phone: '+51 991 789 456',
        description: 'Cardiólogo clínico intervencionista especializado en insuficiencia cardíaca e hipertensión.',
        experienceYears: 12,
        consultationFee: 120.0,
        image: 'https://images.unsplash.com/photo-1537368910025-700350fe46c7?w=400&q=80',
        rating: 5.0,
        reviewsCount: 56,
      ),
      Doctor(
        id: 'doc_4',
        name: 'Lucía',
        lastname: 'Morales',
        cmp: 'CMP-48903',
        specialtyId: '4',
        specialtyName: 'Dermatología',
        email: 'dra.morales@mediapp.com',
        phone: '+51 976 543 210',
        description: 'Dermatóloga clínica y cosmética, tratamientos avanzados para acné, rosácea y rejuvenecimiento.',
        experienceYears: 7,
        consultationFee: 90.0,
        image: 'https://images.unsplash.com/photo-1594824813589-4091a0c0ad75?w=400&q=80',
        rating: 4.9,
        reviewsCount: 29,
      ),
      Doctor(
        id: 'doc_5',
        name: 'Elena',
        lastname: 'Salazar',
        cmp: 'CMP-44321',
        specialtyId: '5',
        specialtyName: 'Ginecología',
        email: 'dra.salazar@mediapp.com',
        phone: '+51 965 432 198',
        description: 'Gineco-obstetra con amplia trayectoria en salud reproductiva, ecografías y control prenatal.',
        experienceYears: 10,
        consultationFee: 100.0,
        image: 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=400&q=80',
        rating: 4.9,
        reviewsCount: 48,
      ),
    ];

    _schedules = [
      DoctorSchedule(
        id: 'sch_1',
        doctorId: 'doc_1',
        dayOfWeek: 1,
        dayName: 'Lunes',
        morningShift: '08:00 - 13:00',
        afternoonShift: '15:00 - 18:00',
        defaultSlots: ['08:00 AM', '08:30 AM', '09:00 AM', '09:30 AM', '10:00 AM', '10:30 AM', '11:00 AM', '11:30 AM', '03:00 PM', '03:30 PM', '04:00 PM', '04:30 PM', '05:00 PM'],
      ),
      DoctorSchedule(
        id: 'sch_2',
        doctorId: 'doc_1',
        dayOfWeek: 3,
        dayName: 'Miércoles',
        morningShift: '08:00 - 13:00',
        afternoonShift: '15:00 - 18:00',
        defaultSlots: ['08:00 AM', '08:30 AM', '09:00 AM', '09:30 AM', '10:00 AM', '10:30 AM', '11:00 AM', '11:30 AM', '03:00 PM', '03:30 PM', '04:00 PM', '04:30 PM'],
      ),
      DoctorSchedule(
        id: 'sch_3',
        doctorId: 'doc_1',
        dayOfWeek: 5,
        dayName: 'Viernes',
        morningShift: '08:00 - 13:00',
        afternoonShift: '15:00 - 18:00',
        defaultSlots: ['08:00 AM', '08:30 AM', '09:00 AM', '09:30 AM', '10:00 AM', '10:30 AM', '11:00 AM', '11:30 AM'],
      ),
    ];

    final now = DateTime.now();
    _appointments = [
      Appointment(
        id: 'apt_1',
        patientId: '1',
        patientName: 'Josué Quiroz',
        patientPhone: '+51 987 111 222',
        doctorId: 'doc_1',
        doctorName: 'Carlos Mendoza',
        doctorSpecialty: 'Pediatría',
        doctorImage: 'https://images.unsplash.com/photo-1622253692010-333f2da6031d?w=400&q=80',
        appointmentDate: now.add(const Duration(days: 2)),
        appointmentTime: '10:00 AM',
        status: AppointmentStatus.CONFIRMADA,
        reason: 'Control pediátrico y revisión de esquema de vacunación.',
        consultationFee: 80.0,
        createdAt: now.subtract(const Duration(days: 1)),
      ),
      Appointment(
        id: 'apt_2',
        patientId: '1',
        patientName: 'Josué Quiroz',
        patientPhone: '+51 987 111 222',
        doctorId: 'doc_2',
        doctorName: 'Ana Torres',
        doctorSpecialty: 'Medicina General',
        doctorImage: 'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?w=400&q=80',
        appointmentDate: now.subtract(const Duration(days: 14)),
        appointmentTime: '02:00 PM',
        status: AppointmentStatus.ATENDIDA,
        reason: 'Malestar general y dolor de garganta.',
        consultationFee: 60.0,
        diagnosis: 'Faringoamigdalitis aguda bacteriana leve.',
        treatment: 'Amoxicilina 500mg cada 8 horas por 7 días. Paracetamol 500mg si hay dolor o fiebre.',
        notes: 'Paciente evoluciona favorablemente. Hidratación abundante y reposo relativo.',
        createdAt: now.subtract(const Duration(days: 16)),
      ),
      Appointment(
        id: 'apt_3',
        patientId: '1',
        patientName: 'Josué Quiroz',
        patientPhone: '+51 987 111 222',
        doctorId: 'doc_3',
        doctorName: 'Roberto Vásquez',
        doctorSpecialty: 'Cardiología',
        doctorImage: 'https://images.unsplash.com/photo-1537368910025-700350fe46c7?w=400&q=80',
        appointmentDate: now.subtract(const Duration(days: 30)),
        appointmentTime: '11:00 AM',
        status: AppointmentStatus.CANCELADA,
        reason: 'Chequeo cardiológico anual.',
        consultationFee: 120.0,
        notes: 'Cancelada por el paciente por viaje imprevisto.',
        createdAt: now.subtract(const Duration(days: 32)),
      ),
    ];

    _history = [
      MedicalHistory(
        id: 'his_1',
        appointmentId: 'apt_2',
        patientId: '1',
        patientName: 'Josué Quiroz',
        doctorId: 'doc_2',
        doctorName: 'Dra. Ana Torres',
        specialty: 'Medicina General',
        date: now.subtract(const Duration(days: 14)),
        reason: 'Malestar general, odinofagia y febrícula.',
        diagnosis: 'Faringoamigdalitis aguda eritematosa.',
        treatment: '1. Amoxicilina 500 mg: Tomar 1 cápsula cada 8 horas por 7 días.\n2. Paracetamol 500 mg: 1 tableta cada 8 horas condicional a dolor.\n3. Abundantes líquidos tibios.',
        observations: 'Paciente tolera vía oral. Sin signos de dificultad respiratoria. Control en caso de persistencia.',
      ),
      MedicalHistory(
        id: 'his_2',
        appointmentId: 'apt_old',
        patientId: '1',
        patientName: 'Josué Quiroz',
        doctorId: 'doc_4',
        doctorName: 'Dra. Lucía Morales',
        specialty: 'Dermatología',
        date: now.subtract(const Duration(days: 60)),
        reason: 'Erupción cutánea pruriginosa en antebrazo.',
        diagnosis: 'Dermatitis por contacto alérgica.',
        treatment: '1. Crema tópica con hidrocortisona al 1% cada 12 horas por 5 días.\n2. Cetirizina 10mg: 1 tableta por la noche por 3 días.',
        observations: 'Evitar contacto con detergentes concentrados. Mejoría clínica completa esperada en 5 días.',
      ),
    ];
  }

  // --- Especialidades ---
  List<Specialty> getSpecialties() => List.unmodifiable(_specialties);

  Specialty? getSpecialtyById(String id) {
    try {
      return _specialties.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }

  // --- Médicos ---
  List<Doctor> getDoctors({String? specialtyId}) {
    if (specialtyId == null || specialtyId.isEmpty) {
      return List.unmodifiable(_doctors);
    }
    return _doctors.where((d) => d.specialtyId == specialtyId).toList();
  }

  Doctor? getDoctorById(String id) {
    try {
      return _doctors.firstWhere((d) => d.id == id);
    } catch (_) {
      return null;
    }
  }

  // --- Horarios y Disponibilidad con Validación de Doble Reserva ---
  List<String> getAvailableSlots(String doctorId, DateTime date) {
    // Horarios base
    final baseSlots = [
      '08:00 AM',
      '08:30 AM',
      '09:00 AM',
      '09:30 AM',
      '10:00 AM',
      '10:30 AM',
      '11:00 AM',
      '11:30 AM',
      '03:00 PM',
      '03:30 PM',
      '04:00 PM',
      '04:30 PM',
      '05:00 PM',
    ];

    // Buscar citas confirmadas o pendientes para ese médico en esa fecha
    final bookedTimes = _appointments
        .where((apt) =>
            apt.doctorId == doctorId &&
            apt.appointmentDate.year == date.year &&
            apt.appointmentDate.month == date.month &&
            apt.appointmentDate.day == date.day &&
            (apt.status == AppointmentStatus.CONFIRMADA ||
                apt.status == AppointmentStatus.PENDIENTE))
        .map((apt) => apt.appointmentTime)
        .toSet();

    return baseSlots.where((slot) => !bookedTimes.contains(slot)).toList();
  }

  List<String> getAllDaySlots() {
    return [
      '08:00 AM',
      '08:30 AM',
      '09:00 AM',
      '09:30 AM',
      '10:00 AM',
      '10:30 AM',
      '11:00 AM',
      '11:30 AM',
      '03:00 PM',
      '03:30 PM',
      '04:00 PM',
      '04:30 PM',
      '05:00 PM',
    ];
  }

  bool isSlotBooked(String doctorId, DateTime date, String slot) {
    return _appointments.any((apt) =>
        apt.doctorId == doctorId &&
        apt.appointmentDate.year == date.year &&
        apt.appointmentDate.month == date.month &&
        apt.appointmentDate.day == date.day &&
        apt.appointmentTime == slot &&
        (apt.status == AppointmentStatus.CONFIRMADA ||
            apt.status == AppointmentStatus.PENDIENTE));
  }

  // --- Citas ---
  List<Appointment> getAppointments({String? patientId, String? doctorId}) {
    var list = _appointments;
    if (patientId != null && patientId.isNotEmpty) {
      list = list.where((a) => a.patientId == patientId).toList();
    }
    if (doctorId != null && doctorId.isNotEmpty) {
      list = list.where((a) => a.doctorId == doctorId).toList();
    }
    // Ordenar: primero próximas fechas
    list.sort((a, b) => b.appointmentDate.compareTo(a.appointmentDate));
    return List.unmodifiable(list);
  }

  Appointment? getAppointmentById(String id) {
    try {
      return _appointments.firstWhere((a) => a.id == id);
    } catch (_) {
      return null;
    }
  }

  Appointment bookAppointment(Appointment appointment) {
    // Validación contra doble reserva
    final isAlreadyBooked = isSlotBooked(
      appointment.doctorId,
      appointment.appointmentDate,
      appointment.appointmentTime,
    );
    if (isAlreadyBooked) {
      throw Exception('El horario seleccionado ya no se encuentra disponible.');
    }

    _appointments.insert(0, appointment);
    return appointment;
  }

  bool cancelAppointment(String appointmentId) {
    final index = _appointments.indexWhere((a) => a.id == appointmentId);
    if (index != -1) {
      _appointments[index] = _appointments[index].copyWith(
        status: AppointmentStatus.CANCELADA,
      );
      return true;
    }
    return false;
  }

  bool rescheduleAppointment(String appointmentId, DateTime newDate, String newTime) {
    final index = _appointments.indexWhere((a) => a.id == appointmentId);
    if (index != -1) {
      final apt = _appointments[index];
      if (isSlotBooked(apt.doctorId, newDate, newTime)) {
        throw Exception('El nuevo horario seleccionado ya está ocupado.');
      }
      _appointments[index] = apt.copyWith(
        appointmentDate: newDate,
        appointmentTime: newTime,
        status: AppointmentStatus.REPROGRAMADA,
      );
      return true;
    }
    return false;
  }

  // Atención médica por parte del doctor
  bool attendAppointment({
    required String appointmentId,
    required String diagnosis,
    required String treatment,
    required String observations,
  }) {
    final index = _appointments.indexWhere((a) => a.id == appointmentId);
    if (index != -1) {
      final apt = _appointments[index];
      _appointments[index] = apt.copyWith(
        status: AppointmentStatus.ATENDIDA,
        diagnosis: diagnosis,
        treatment: treatment,
        notes: observations,
      );

      // Crear nuevo registro en el historial clínico del paciente automáticamente
      final newHistory = MedicalHistory(
        id: 'his_${DateTime.now().millisecondsSinceEpoch}',
        appointmentId: appointmentId,
        patientId: apt.patientId,
        patientName: apt.patientName,
        doctorId: apt.doctorId,
        doctorName: 'Dr. ${apt.doctorName}',
        specialty: apt.doctorSpecialty,
        date: apt.appointmentDate,
        reason: apt.reason,
        diagnosis: diagnosis,
        treatment: treatment,
        observations: observations,
      );
      _history.insert(0, newHistory);
      return true;
    }
    return false;
  }

  // --- Historial Médico ---
  List<MedicalHistory> getMedicalHistory(String patientId) {
    final list = _history.where((h) => h.patientId == patientId).toList();
    list.sort((a, b) => b.date.compareTo(a.date));
    return List.unmodifiable(list);
  }

  // --- Horarios del Médico ---
  List<DoctorSchedule> getDoctorSchedules(String doctorId) {
    return _schedules.where((s) => s.doctorId == doctorId).toList();
  }

  bool updateDoctorSchedule(DoctorSchedule schedule) {
    final index = _schedules.indexWhere((s) => s.id == schedule.id);
    if (index != -1) {
      _schedules[index] = schedule;
      return true;
    } else {
      _schedules.add(schedule);
      return true;
    }
  }

  // --- Métricas para Administrador y Médico ---
  Map<String, int> getAdminMetrics() {
    final totalPatients = 124;
    final totalDoctors = _doctors.length;
    final today = DateTime.now();
    final todayAppointments = _appointments.where((a) =>
        a.appointmentDate.year == today.year &&
        a.appointmentDate.month == today.month &&
        a.appointmentDate.day == today.day).length;
    final attendedAppointments = _appointments.where((a) => a.status == AppointmentStatus.ATENDIDA).length;
    final pendingAppointments = _appointments.where((a) => a.status == AppointmentStatus.PENDIENTE || a.status == AppointmentStatus.CONFIRMADA).length;

    return {
      'patients': totalPatients,
      'doctors': totalDoctors,
      'today': todayAppointments > 0 ? todayAppointments : 4,
      'attended': attendedAppointments,
      'pending': pendingAppointments,
    };
  }
}
