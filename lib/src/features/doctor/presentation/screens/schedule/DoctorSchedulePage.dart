import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:myfirstlove/injection.dart';
import 'package:myfirstlove/src/constants/app_colors.dart';
import 'package:myfirstlove/src/constants/app_text_styles.dart';
import 'package:myfirstlove/src/domain/models/Schedule.dart';
import 'package:myfirstlove/src/domain/useCase/doctors/DoctorsUseCases.dart';
import 'package:myfirstlove/src/domain/utils/Resource.dart';

class DoctorSchedulePage extends StatefulWidget {
  final String doctorId;

  const DoctorSchedulePage({super.key, this.doctorId = 'doc_1'});

  @override
  State<DoctorSchedulePage> createState() => _DoctorSchedulePageState();
}

class _DoctorSchedulePageState extends State<DoctorSchedulePage> {
  final DoctorsUseCases _doctorsUseCases = locator<DoctorsUseCases>();
  List<DoctorSchedule> _schedules = [];
  bool _isLoading = true;

  final List<String> _days = [
    'Lunes',
    'Martes',
    'Miércoles',
    'Jueves',
    'Viernes',
    'Sábado'
  ];

  @override
  void initState() {
    super.initState();
    _loadSchedules();
  }

  Future<void> _loadSchedules() async {
    setState(() => _isLoading = true);
    final res = await _doctorsUseCases.getDoctorSchedules.run(widget.doctorId);
    if (res is Success<List<DoctorSchedule>>) {
      _schedules = res.data;
    }
    // Asegurar que existan registros para los días
    if (_schedules.isEmpty) {
      _schedules = [
        DoctorSchedule(
          id: 'sch_1',
          doctorId: widget.doctorId,
          dayOfWeek: 1,
          dayName: 'Lunes',
          morningShift: '08:00 - 13:00',
          afternoonShift: '15:00 - 18:00',
          defaultSlots: [],
          isActive: true,
        ),
        DoctorSchedule(
          id: 'sch_2',
          doctorId: widget.doctorId,
          dayOfWeek: 2,
          dayName: 'Martes',
          morningShift: '08:00 - 13:00',
          afternoonShift: 'No atiende',
          defaultSlots: [],
          isActive: true,
        ),
        DoctorSchedule(
          id: 'sch_3',
          doctorId: widget.doctorId,
          dayOfWeek: 3,
          dayName: 'Miércoles',
          morningShift: '08:00 - 13:00',
          afternoonShift: '15:00 - 18:00',
          defaultSlots: [],
          isActive: true,
        ),
        DoctorSchedule(
          id: 'sch_4',
          doctorId: widget.doctorId,
          dayOfWeek: 4,
          dayName: 'Jueves',
          morningShift: '08:00 - 13:00',
          afternoonShift: 'No atiende',
          defaultSlots: [],
          isActive: true,
        ),
        DoctorSchedule(
          id: 'sch_5',
          doctorId: widget.doctorId,
          dayOfWeek: 5,
          dayName: 'Viernes',
          morningShift: '08:00 - 13:00',
          afternoonShift: '15:00 - 18:00',
          defaultSlots: [],
          isActive: true,
        ),
      ];
    }
    setState(() => _isLoading = false);
  }

  Future<void> _editShift(DoctorSchedule schedule, bool isMorning) async {
    final controller = TextEditingController(
      text: isMorning ? schedule.morningShift : schedule.afternoonShift,
    );

    final newShift = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('${schedule.dayName} - ${isMorning ? "Turno Mañana" : "Turno Tarde"}'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Horario (ej. 08:00 - 13:00 o No atiende)',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, null),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, controller.text.trim()),
            child: const Text('Guardar'),
          ),
        ],
      ),
    );

    if (newShift != null && newShift.isNotEmpty) {
      final updated = schedule.copyWith(
        morningShift: isMorning ? newShift : schedule.morningShift,
        afternoonShift: !isMorning ? newShift : schedule.afternoonShift,
      );
      final res = await _doctorsUseCases.updateDoctorSchedule.run(updated);
      if (res is Success) {
        Fluttertoast.showToast(msg: 'Horario actualizado correctamente.');
        _loadSchedules();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primarySoft,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.info_outline, color: AppColors.primary),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Configura tus turnos de atención. El sistema calculará automáticamente tus horas disponibles.',
                        style: TextStyle(color: AppColors.primary, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              ..._schedules.map((sch) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 1.5,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(sch.dayName, style: AppTextStyles.cardTitle),
                            Switch(
                              value: sch.isActive,
                              activeColor: AppColors.primary,
                              onChanged: (val) async {
                                final updated = sch.copyWith(isActive: val);
                                await _doctorsUseCases.updateDoctorSchedule.run(updated);
                                _loadSchedules();
                              },
                            ),
                          ],
                        ),
                        const Divider(),
                        ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.wb_sunny_outlined, color: Colors.orange),
                          title: const Text('Turno Mañana:'),
                          subtitle: Text(sch.morningShift, style: const TextStyle(fontWeight: FontWeight.bold)),
                          trailing: IconButton(
                            icon: const Icon(Icons.edit, size: 18),
                            onPressed: () => _editShift(sch, true),
                          ),
                        ),
                        ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.nightlight_round, color: Colors.indigo),
                          title: const Text('Turno Tarde:'),
                          subtitle: Text(sch.afternoonShift, style: const TextStyle(fontWeight: FontWeight.bold)),
                          trailing: IconButton(
                            icon: const Icon(Icons.edit, size: 18),
                            onPressed: () => _editShift(sch, false),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ],
          );
  }
}
