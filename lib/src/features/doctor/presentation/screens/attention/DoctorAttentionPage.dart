import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:myfirstlove/injection.dart';
import 'package:myfirstlove/src/constants/app_colors.dart';
import 'package:myfirstlove/src/constants/app_text_styles.dart';
import 'package:myfirstlove/src/domain/models/Appointment.dart';
import 'package:myfirstlove/src/domain/useCase/appointments/AppointmentsUseCases.dart';
import 'package:myfirstlove/src/domain/utils/Resource.dart';

class DoctorAttentionPage extends StatefulWidget {
  final Appointment appointment;

  const DoctorAttentionPage({super.key, required this.appointment});

  @override
  State<DoctorAttentionPage> createState() => _DoctorAttentionPageState();
}

class _DoctorAttentionPageState extends State<DoctorAttentionPage> {
  final AppointmentsUseCases _appointmentsUseCases =
      locator<AppointmentsUseCases>();

  late TextEditingController _reasonController;
  final TextEditingController _diagnosisController = TextEditingController();
  final TextEditingController _treatmentController = TextEditingController();
  final TextEditingController _observationsController = TextEditingController();

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _reasonController = TextEditingController(text: widget.appointment.reason);
  }

  @override
  void dispose() {
    _reasonController.dispose();
    _diagnosisController.dispose();
    _treatmentController.dispose();
    _observationsController.dispose();
    super.dispose();
  }

  Future<void> _saveAttention() async {
    final diagnosis = _diagnosisController.text.trim();
    final treatment = _treatmentController.text.trim();
    final observations = _observationsController.text.trim();

    if (diagnosis.isEmpty) {
      Fluttertoast.showToast(msg: 'Por favor ingresa el diagnóstico médico.');
      return;
    }
    if (treatment.isEmpty) {
      Fluttertoast.showToast(msg: 'Por favor ingresa el tratamiento o prescripción.');
      return;
    }

    setState(() => _isSaving = true);

    final res = await _appointmentsUseCases.attendAppointment.run(
      appointmentId: widget.appointment.id,
      diagnosis: diagnosis,
      treatment: treatment,
      observations: observations,
    );

    setState(() => _isSaving = false);

    if (res is Success) {
      Fluttertoast.showToast(
        msg: 'Atención registrada con éxito. Cita marcada como ATENDIDA.',
        toastLength: Toast.LENGTH_LONG,
      );
      if (!mounted) return;
      Navigator.pop(context, true);
    } else if (res is Error) {
      Fluttertoast.showToast(msg: (res as Error).message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final apt = widget.appointment;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Atender Paciente'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Resumen de la Cita y Paciente
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.inputBorder.withOpacity(0.5)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 24,
                        backgroundColor: AppColors.primarySoft,
                        child: Icon(Icons.person, color: AppColors.primary, size: 28),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              apt.patientName,
                              style: AppTextStyles.cardTitle.copyWith(fontSize: 16),
                            ),
                            Text(
                              'Tel: ${apt.patientPhone}',
                              style: AppTextStyles.caption.copyWith(fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Fecha: ${apt.appointmentDate.day}/${apt.appointmentDate.month}/${apt.appointmentDate.year}',
                          style: const TextStyle(fontWeight: FontWeight.w600)),
                      Text('Hora: ${apt.appointmentTime}',
                          style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.primary)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Formulario de Atención Clínica
            Text('Registro de la Consulta Clínica', style: AppTextStyles.sectionTitle),
            const SizedBox(height: 16),

            // Motivo de consulta
            _buildField(
              label: 'Motivo de consulta',
              controller: _reasonController,
              maxLines: 2,
              hint: 'Motivo manifestado por el paciente',
            ),
            const SizedBox(height: 16),

            // Diagnóstico
            _buildField(
              label: 'Diagnóstico Médico (*)',
              controller: _diagnosisController,
              maxLines: 3,
              hint: 'Ej: Faringoamigdalitis aguda bacteriana...',
            ),
            const SizedBox(height: 16),

            // Tratamiento
            _buildField(
              label: 'Tratamiento y Prescripción (*)',
              controller: _treatmentController,
              maxLines: 4,
              hint: 'Medicamentos, dosis, frecuencia y duración...',
            ),
            const SizedBox(height: 16),

            // Observaciones
            _buildField(
              label: 'Observaciones y Recomendaciones',
              controller: _observationsController,
              maxLines: 3,
              hint: 'Recomendaciones generales, signos de alarma, fecha sugerida de control...',
            ),
            const SizedBox(height: 28),

            // Botón Guardar Atención
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: _isSaving ? null : _saveAttention,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: _isSaving
                    ? const SizedBox.shrink()
                    : const Icon(Icons.check_circle_outline, color: Colors.white),
                label: _isSaving
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Guardar Atención Médica',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    required int maxLines,
    required String hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.inputBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
