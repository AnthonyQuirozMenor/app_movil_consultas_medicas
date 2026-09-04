import 'package:flutter/material.dart';
import 'package:myfirstlove/injection.dart';
import 'package:myfirstlove/src/constants/app_colors.dart';
import 'package:myfirstlove/src/constants/app_text_styles.dart';
import 'package:myfirstlove/src/domain/models/MedicalHistory.dart';
import 'package:myfirstlove/src/domain/useCase/Auth/AuthUseCases.dart';
import 'package:myfirstlove/src/domain/useCase/medicalHistory/MedicalHistoryUseCases.dart';
import 'package:myfirstlove/src/domain/utils/Resource.dart';

class MedicalHistoryPage extends StatefulWidget {
  final bool isStandalone;

  const MedicalHistoryPage({super.key, this.isStandalone = false});

  @override
  State<MedicalHistoryPage> createState() => _MedicalHistoryPageState();
}

class _MedicalHistoryPageState extends State<MedicalHistoryPage> {
  final MedicalHistoryUseCases _medicalHistoryUseCases =
      locator<MedicalHistoryUseCases>();
  final AuthUseCases _authUseCases = locator<AuthUseCases>();

  List<MedicalHistory> _historyList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    setState(() => _isLoading = true);
    final userSession = await _authUseCases.getUserSessionUseCase.run();
    final patientId = userSession?.user.id?.toString() ?? '1';

    final res = await _medicalHistoryUseCases.getMedicalHistory.run(patientId);
    if (res is Success<List<MedicalHistory>>) {
      setState(() {
        _historyList = res.data;
      });
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final content = _isLoading
        ? const Center(child: CircularProgressIndicator())
        : _historyList.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.history_edu, size: 70, color: AppColors.textMuted),
                      SizedBox(height: 16),
                      Text(
                        'Aún no cuentas con atenciones médicas registradas.',
                        style: AppTextStyles.body,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              )
            : RefreshIndicator(
                onRefresh: _loadHistory,
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: _historyList.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final item = _historyList[index];
                    return _buildHistoryCard(item);
                  },
                ),
              );

    if (widget.isStandalone) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('Historial Médico Clínico'),
        ),
        body: content,
      );
    }

    return content;
  }

  Widget _buildHistoryCard(MedicalHistory item) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.inputBorder.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Especialidad y Fecha
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primarySoft,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  item.specialty,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 14, color: AppColors.textMuted),
                  const SizedBox(width: 4),
                  Text(
                    '${item.date.day.toString().padLeft(2, '0')}/${item.date.month.toString().padLeft(2, '0')}/${item.date.year}',
                    style: AppTextStyles.caption.copyWith(fontSize: 13),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Médico
          Row(
            children: [
              const Icon(Icons.medical_services_outlined, size: 18, color: AppColors.textSecondary),
              const SizedBox(width: 6),
              Text(
                item.doctorName,
                style: AppTextStyles.cardTitle.copyWith(fontSize: 15),
              ),
            ],
          ),
          const Divider(height: 22),

          // Diagnóstico
          _buildClinicalField(
            title: 'Diagnóstico:',
            content: item.diagnosis,
            icon: Icons.search,
            color: AppColors.primary,
          ),
          const SizedBox(height: 12),

          // Tratamiento
          _buildClinicalField(
            title: 'Tratamiento y Receta:',
            content: item.treatment,
            icon: Icons.medication_outlined,
            color: AppColors.success,
          ),

          // Observaciones
          if (item.observations.isNotEmpty) ...[
            const SizedBox(height: 12),
            _buildClinicalField(
              title: 'Observaciones Médicas:',
              content: item.observations,
              icon: Icons.info_outline,
              color: AppColors.textSecondary,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildClinicalField({
    required String title,
    required String content,
    required IconData icon,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 6),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.only(left: 22.0),
          child: Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textPrimary,
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }
}
