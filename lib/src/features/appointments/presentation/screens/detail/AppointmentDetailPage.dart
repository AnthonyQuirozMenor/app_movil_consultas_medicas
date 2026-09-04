import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:myfirstlove/injection.dart';
import 'package:myfirstlove/src/constants/app_colors.dart';
import 'package:myfirstlove/src/constants/app_text_styles.dart';
import 'package:myfirstlove/src/domain/models/Appointment.dart';
import 'package:myfirstlove/src/domain/useCase/appointments/AppointmentsUseCases.dart';
import 'package:myfirstlove/src/domain/utils/Resource.dart';

class AppointmentDetailPage extends StatefulWidget {
  final Appointment appointment;

  const AppointmentDetailPage({super.key, required this.appointment});

  @override
  State<AppointmentDetailPage> createState() => _AppointmentDetailPageState();
}

class _AppointmentDetailPageState extends State<AppointmentDetailPage> {
  final AppointmentsUseCases _appointmentsUseCases =
      locator<AppointmentsUseCases>();
  late Appointment _appointment;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _appointment = widget.appointment;
  }

  Future<void> _cancelAppointment() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('¿Cancelar cita médica?'),
        content: const Text(
          'Esta acción liberará el horario del médico para otros pacientes. ¿Deseas continuar?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('No, conservar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Sí, cancelar'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isLoading = true);
    final res =
        await _appointmentsUseCases.cancelAppointment.run(_appointment.id);
    setState(() => _isLoading = false);

    if (res is Success) {
      Fluttertoast.showToast(msg: 'La cita fue cancelada correctamente.');
      setState(() {
        _appointment = _appointment.copyWith(status: AppointmentStatus.CANCELADA);
      });
    } else if (res is Error) {
      Fluttertoast.showToast(msg: (res as Error).message);
    }
  }

  Future<void> _rescheduleAppointment() async {
    final DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now().add(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );

    if (newDate == null) return;

    // Obtener slots disponibles para la nueva fecha
    final slotsRes = await _appointmentsUseCases.getAvailableSlots.run(
      _appointment.doctorId,
      newDate,
    );

    List<String> availableSlots = [];
    if (slotsRes is Success<List<String>>) {
      availableSlots = slotsRes.data;
    }

    if (availableSlots.isEmpty) {
      Fluttertoast.showToast(
        msg: 'No hay horarios disponibles para la fecha seleccionada.',
      );
      return;
    }

    if (!mounted) return;

    String? chosenTime = availableSlots.first;
    final selectedTime = await showDialog<String>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Selecciona nuevo horario'),
          content: DropdownButton<String>(
            value: chosenTime,
            isExpanded: true,
            items: availableSlots
                .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                .toList(),
            onChanged: (val) {
              setDialogState(() {
                chosenTime = val;
              });
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, null),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx, chosenTime),
              child: const Text('Reprogramar'),
            ),
          ],
        ),
      ),
    );

    if (selectedTime == null) return;

    setState(() => _isLoading = true);
    final res = await _appointmentsUseCases.rescheduleAppointment.run(
      _appointment.id,
      newDate,
      selectedTime,
    );
    setState(() => _isLoading = false);

    if (res is Success) {
      Fluttertoast.showToast(msg: 'Cita reprogramada con éxito.');
      setState(() {
        _appointment = _appointment.copyWith(
          appointmentDate: newDate,
          appointmentTime: selectedTime,
          status: AppointmentStatus.REPROGRAMADA,
        );
      });
    } else if (res is Error) {
      Fluttertoast.showToast(msg: (res as Error).message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = _appointment.status;
    final canModify = status == AppointmentStatus.PENDIENTE ||
        status == AppointmentStatus.CONFIRMADA ||
        status == AppointmentStatus.REPROGRAMADA;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Detalle de la Cita'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // Tarjeta Principal
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Estado y Badge
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Estado de la Cita',
                              style: AppTextStyles.caption.copyWith(fontSize: 13),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: status.color.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(status.icon,
                                      size: 16, color: status.color),
                                  const SizedBox(width: 4),
                                  Text(
                                    status.displayName,
                                    style: TextStyle(
                                      color: status.color,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 28),

                        // Datos del Médico
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 32,
                              backgroundImage:
                                  NetworkImage(_appointment.doctorImage),
                              backgroundColor: AppColors.primarySoft,
                              child: _appointment.doctorImage.isEmpty
                                  ? const Icon(Icons.person,
                                      size: 32, color: AppColors.primary)
                                  : null,
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Dr. ${_appointment.doctorName}',
                                    style: AppTextStyles.cardTitle.copyWith(fontSize: 17),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _appointment.doctorSpecialty,
                                    style: const TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 28),

                        // Fecha y Hora
                        _buildInfoRow(
                          icon: Icons.calendar_today,
                          label: 'Fecha',
                          value:
                              '${_appointment.appointmentDate.day.toString().padLeft(2, '0')}/${_appointment.appointmentDate.month.toString().padLeft(2, '0')}/${_appointment.appointmentDate.year}',
                        ),
                        const SizedBox(height: 14),
                        _buildInfoRow(
                          icon: Icons.access_time,
                          label: 'Hora',
                          value: _appointment.appointmentTime,
                        ),
                        const SizedBox(height: 14),
                        _buildInfoRow(
                          icon: Icons.person_outline,
                          label: 'Paciente',
                          value: _appointment.patientName,
                        ),
                        const SizedBox(height: 14),
                        _buildInfoRow(
                          icon: Icons.phone_outlined,
                          label: 'Teléfono',
                          value: _appointment.patientPhone,
                        ),
                        const SizedBox(height: 14),
                        _buildInfoRow(
                          icon: Icons.payments_outlined,
                          label: 'Costo de Consulta',
                          value: 'S/ ${_appointment.consultationFee.toStringAsFixed(2)}',
                        ),
                        const SizedBox(height: 14),
                        _buildInfoRow(
                          icon: Icons.notes_outlined,
                          label: 'Motivo',
                          value: _appointment.reason,
                        ),

                        // Si fue atendida, mostrar Diagnóstico y Tratamiento
                        if (status == AppointmentStatus.ATENDIDA) ...[
                          const Divider(height: 28),
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: AppColors.primarySoft,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: const [
                                    Icon(Icons.assignment_turned_in,
                                        color: AppColors.primary, size: 20),
                                    SizedBox(width: 8),
                                    Text(
                                      'Diagnóstico y Tratamiento Registrado',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Diagnóstico: ${_appointment.diagnosis ?? "Sin diagnóstico registrado"}',
                                  style: const TextStyle(fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 6),
                                Text('Tratamiento: ${_appointment.treatment ?? "No especificado"}'),
                                if (_appointment.notes != null) ...[
                                  const SizedBox(height: 6),
                                  Text('Observaciones: ${_appointment.notes}'),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Botones contextuales
                  if (canModify) ...[
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _rescheduleAppointment,
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              side: const BorderSide(color: AppColors.primary),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            icon: const Icon(Icons.event_repeat,
                                color: AppColors.primary),
                            label: const Text(
                              'Reprogramar',
                              style: TextStyle(color: AppColors.primary),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _cancelAppointment,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.error,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            icon: const Icon(Icons.cancel_outlined,
                                color: Colors.white),
                            label: const Text(
                              'Cancelar Cita',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: AppColors.textSecondary),
        const SizedBox(width: 12),
        SizedBox(
          width: 110,
          child: Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
