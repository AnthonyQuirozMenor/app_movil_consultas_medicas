import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:myfirstlove/injection.dart';
import 'package:myfirstlove/src/constants/app_colors.dart';
import 'package:myfirstlove/src/constants/app_text_styles.dart';
import 'package:myfirstlove/src/domain/models/Appointment.dart';
import 'package:myfirstlove/src/domain/models/Doctor.dart';
import 'package:myfirstlove/src/domain/models/Specialty.dart';
import 'package:myfirstlove/src/domain/useCase/Auth/AuthUseCases.dart';
import 'package:myfirstlove/src/domain/useCase/appointments/AppointmentsUseCases.dart';
import 'package:myfirstlove/src/domain/useCase/doctors/DoctorsUseCases.dart';
import 'package:myfirstlove/src/domain/useCase/specialties/SpecialtiesUseCases.dart';
import 'package:myfirstlove/src/domain/utils/Resource.dart';

class BookAppointmentPage extends StatefulWidget {
  final Specialty? initialSpecialty;
  final Doctor? initialDoctor;

  const BookAppointmentPage({
    super.key,
    this.initialSpecialty,
    this.initialDoctor,
  });

  @override
  State<BookAppointmentPage> createState() => _BookAppointmentPageState();
}

class _BookAppointmentPageState extends State<BookAppointmentPage> {
  final SpecialtiesUseCases _specialtiesUseCases = locator<SpecialtiesUseCases>();
  final DoctorsUseCases _doctorsUseCases = locator<DoctorsUseCases>();
  final AppointmentsUseCases _appointmentsUseCases = locator<AppointmentsUseCases>();
  final AuthUseCases _authUseCases = locator<AuthUseCases>();

  List<Specialty> _specialties = [];
  List<Doctor> _doctors = [];
  List<String> _availableSlots = [];
  final List<String> _allDaySlots = [
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

  Specialty? _selectedSpecialty;
  Doctor? _selectedDoctor;
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  String? _selectedTime;
  final TextEditingController _reasonController = TextEditingController();

  bool _isLoading = true;
  bool _isBooking = false;

  @override
  void initState() {
    super.initState();
    _selectedSpecialty = widget.initialSpecialty;
    _selectedDoctor = widget.initialDoctor;
    _loadInitialData();
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    setState(() => _isLoading = true);
    final specRes = await _specialtiesUseCases.getSpecialties.run();
    if (specRes is Success<List<Specialty>>) {
      _specialties = specRes.data;
      if (_selectedSpecialty == null && _specialties.isNotEmpty) {
        _selectedSpecialty = _specialties.first;
      }
    }

    await _loadDoctors();
    setState(() => _isLoading = false);
  }

  Future<void> _loadDoctors() async {
    final docRes = await _doctorsUseCases.getDoctors.run(
      specialtyId: _selectedSpecialty?.id,
    );
    if (docRes is Success<List<Doctor>>) {
      setState(() {
        _doctors = docRes.data;
        if (_doctors.isNotEmpty) {
          if (_selectedDoctor == null ||
              !_doctors.any((d) => d.id == _selectedDoctor!.id)) {
            _selectedDoctor = _doctors.first;
          }
        } else {
          _selectedDoctor = null;
        }
      });
      await _loadSlots();
    }
  }

  Future<void> _loadSlots() async {
    if (_selectedDoctor == null) {
      setState(() {
        _availableSlots = [];
        _selectedTime = null;
      });
      return;
    }

    final slotsRes = await _appointmentsUseCases.getAvailableSlots.run(
      _selectedDoctor!.id,
      _selectedDate,
    );
    if (slotsRes is Success<List<String>>) {
      setState(() {
        _availableSlots = slotsRes.data;
        if (_selectedTime != null && !_availableSlots.contains(_selectedTime)) {
          _selectedTime = null;
        }
      });
    }
  }

  Future<void> _onSelectDate(DateTime date) async {
    setState(() {
      _selectedDate = date;
    });
    await _loadSlots();
  }

  Future<void> _confirmBooking() async {
    if (_selectedDoctor == null) {
      Fluttertoast.showToast(msg: 'Por favor selecciona un médico');
      return;
    }
    if (_selectedTime == null) {
      Fluttertoast.showToast(msg: 'Por favor selecciona un horario disponible');
      return;
    }
    final reason = _reasonController.text.trim();
    if (reason.isEmpty) {
      Fluttertoast.showToast(msg: 'Por favor ingresa el motivo de la consulta');
      return;
    }

    setState(() => _isBooking = true);

    final userSession = await _authUseCases.getUserSessionUseCase.run();
    final patientId = userSession?.user.id?.toString() ?? '1';
    final patientName = userSession?.user != null
        ? '${userSession!.user.name} ${userSession.user.lastname}'
        : 'Josué Quiroz';
    final patientPhone = userSession?.user.phone ?? '+51 987 111 222';

    final appointment = Appointment(
      id: 'apt_${DateTime.now().millisecondsSinceEpoch}',
      patientId: patientId,
      patientName: patientName,
      patientPhone: patientPhone,
      doctorId: _selectedDoctor!.id,
      doctorName: '${_selectedDoctor!.name} ${_selectedDoctor!.lastname}',
      doctorSpecialty: _selectedDoctor!.specialtyName,
      doctorImage: _selectedDoctor!.image,
      appointmentDate: _selectedDate,
      appointmentTime: _selectedTime!,
      status: AppointmentStatus.CONFIRMADA,
      reason: reason,
      consultationFee: _selectedDoctor!.consultationFee,
      createdAt: DateTime.now(),
    );

    final result = await _appointmentsUseCases.createAppointment.run(appointment);

    setState(() => _isBooking = false);

    if (result is Success<Appointment>) {
      if (!mounted) return;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: const [
              Icon(Icons.check_circle, color: AppColors.success, size: 28),
              SizedBox(width: 8),
              Text('¡Cita Confirmada!'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Tu cita con ${_selectedDoctor!.fullName} ha sido registrada con éxito.'),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primarySoft,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Especialidad: ${_selectedDoctor!.specialtyName}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text('Fecha: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}'),
                    Text('Hora: $_selectedTime'),
                    Text('Costo: S/ ${_selectedDoctor!.consultationFee.toStringAsFixed(2)}'),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.pop(context, true); // Regresa a home con indicador de actualización
              },
              child: const Text('Entendido'),
            ),
          ],
        ),
      );
    } else if (result is Error) {
      Fluttertoast.showToast(msg: (result as Error).message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Reservar Cita Médica'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Paso 1: Seleccionar Especialidad
                  _buildSectionHeader('1. Selecciona la Especialidad', Icons.medical_services_outlined),
                  const SizedBox(height: 10),
                  _buildSpecialtySelector(),
                  const SizedBox(height: 24),

                  // Paso 2: Seleccionar Médico
                  _buildSectionHeader('2. Selecciona tu Médico Especialista', Icons.person_outline),
                  const SizedBox(height: 10),
                  _buildDoctorSelector(),
                  const SizedBox(height: 24),

                  // Perfil del Médico Seleccionado
                  if (_selectedDoctor != null) ...[
                    _buildDoctorProfileCard(_selectedDoctor!),
                    const SizedBox(height: 24),
                  ],

                  // Paso 3: Seleccionar Fecha
                  _buildSectionHeader('3. Selecciona la Fecha', Icons.calendar_today_outlined),
                  const SizedBox(height: 10),
                  _buildDateSelector(),
                  const SizedBox(height: 24),

                  // Paso 4: Disponibilidad de Horarios
                  _buildSectionHeader('4. Horarios Disponibles', Icons.access_time_outlined),
                  const SizedBox(height: 4),
                  Text(
                    'Las horas en gris ya han sido reservadas por otros pacientes.',
                    style: AppTextStyles.caption,
                  ),
                  const SizedBox(height: 12),
                  _buildTimeSlotGrid(),
                  const SizedBox(height: 24),

                  // Paso 5: Motivo de Consulta
                  _buildSectionHeader('5. Motivo de la Consulta', Icons.edit_note_outlined),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _reasonController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Describe brevemente tus síntomas o el motivo de tu visita...',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Botón de Confirmación
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _isBooking ? null : _confirmBooking,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: _isBooking
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'Confirmar Cita Médica',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 22),
        const SizedBox(width: 8),
        Text(title, style: AppTextStyles.sectionTitle),
      ],
    );
  }

  Widget _buildSpecialtySelector() {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _specialties.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final item = _specialties[index];
          final isSelected = _selectedSpecialty?.id == item.id;
          return ChoiceChip(
            label: Text(item.name),
            selected: isSelected,
            selectedColor: AppColors.primary,
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : AppColors.textPrimary,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(
                color: isSelected ? AppColors.primary : AppColors.inputBorder,
              ),
            ),
            onSelected: (selected) {
              if (selected) {
                setState(() {
                  _selectedSpecialty = item;
                });
                _loadDoctors();
              }
            },
          );
        },
      ),
    );
  }

  Widget _buildDoctorSelector() {
    if (_doctors.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text('No hay médicos registrados para esta especialidad.'),
      );
    }

    return SizedBox(
      height: 120,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _doctors.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final doc = _doctors[index];
          final isSelected = _selectedDoctor?.id == doc.id;
          return InkWell(
            onTap: () {
              setState(() {
                _selectedDoctor = doc;
              });
              _loadSlots();
            },
            borderRadius: BorderRadius.circular(14),
            child: Container(
              width: 220,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primarySoft : Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.inputBorder,
                  width: isSelected ? 2 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundImage: NetworkImage(doc.image),
                    backgroundColor: AppColors.primarySoft,
                    child: doc.image.isEmpty
                        ? const Icon(Icons.person, color: AppColors.primary)
                        : null,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          doc.fullName,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          doc.specialtyName,
                          style: TextStyle(color: AppColors.primary, fontSize: 12),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 14),
                            Text(' ${doc.rating}', style: const TextStyle(fontSize: 11)),
                            const Spacer(),
                            Text(
                              'S/ ${doc.consultationFee.toInt()}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDoctorProfileCard(Doctor doc) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.inputBorder.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.verified, color: AppColors.primary, size: 20),
              const SizedBox(width: 6),
              Text('${doc.cmp} • ${doc.experienceYears} años de experiencia',
                  style: AppTextStyles.bodyBold.copyWith(fontSize: 13, color: AppColors.primary)),
            ],
          ),
          const SizedBox(height: 8),
          Text(doc.description, style: AppTextStyles.body.copyWith(fontSize: 13)),
          const Divider(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.payments_outlined, color: AppColors.textSecondary, size: 18),
                  const SizedBox(width: 6),
                  const Text('Costo de Consulta:'),
                ],
              ),
              Text(
                'S/ ${doc.consultationFee.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector() {
    final now = DateTime.now();
    return SizedBox(
      height: 70,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 14, // Próximos 14 días
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final date = now.add(Duration(days: index + 1));
          final isSelected = date.year == _selectedDate.year &&
              date.month == _selectedDate.month &&
              date.day == _selectedDate.day;

          final weekDays = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];
          final dayName = weekDays[date.weekday - 1];

          return InkWell(
            onTap: () => _onSelectDate(date),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 64,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.inputBorder,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    dayName,
                    style: TextStyle(
                      fontSize: 12,
                      color: isSelected ? Colors.white70 : AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${date.day}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTimeSlotGrid() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _allDaySlots.map((slot) {
        final isAvailable = _availableSlots.contains(slot);
        final isSelected = _selectedTime == slot;

        return InkWell(
          onTap: isAvailable
              ? () {
                  setState(() {
                    _selectedTime = slot;
                  });
                }
              : null,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: !isAvailable
                  ? Colors.grey.shade200
                  : isSelected
                      ? AppColors.primary
                      : Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: !isAvailable
                    ? Colors.grey.shade300
                    : isSelected
                        ? AppColors.primary
                        : AppColors.inputBorder,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  slot,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: !isAvailable
                        ? Colors.grey.shade500
                        : isSelected
                            ? Colors.white
                            : AppColors.textPrimary,
                  ),
                ),
                Text(
                  isAvailable ? 'Disponible' : 'Ocupado',
                  style: TextStyle(
                    fontSize: 10,
                    color: !isAvailable
                        ? Colors.red.shade400
                        : isSelected
                            ? Colors.white70
                            : AppColors.success,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
