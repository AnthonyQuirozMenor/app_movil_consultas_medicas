import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:myfirstlove/injection.dart';
import 'package:myfirstlove/src/constants/app_colors.dart';
import 'package:myfirstlove/src/constants/app_text_styles.dart';
import 'package:myfirstlove/src/domain/models/Appointment.dart';
import 'package:myfirstlove/src/domain/models/AuthResponse.dart';
import 'package:myfirstlove/src/domain/useCase/Auth/AuthUseCases.dart';
import 'package:myfirstlove/src/domain/useCase/appointments/AppointmentsUseCases.dart';
import 'package:myfirstlove/src/domain/utils/Resource.dart';
import 'package:myfirstlove/src/features/doctor/presentation/screens/attention/DoctorAttentionPage.dart';
import 'package:myfirstlove/src/features/doctor/presentation/screens/schedule/DoctorSchedulePage.dart';
import 'package:myfirstlove/src/routing/app_router.dart';

class DoctorHomePage extends StatefulWidget {
  const DoctorHomePage({super.key});

  @override
  State<DoctorHomePage> createState() => _DoctorHomePageState();
}

class _DoctorHomePageState extends State<DoctorHomePage> {
  final AuthUseCases _authUseCases = locator<AuthUseCases>();
  final AppointmentsUseCases _appointmentsUseCases =
      locator<AppointmentsUseCases>();

  int _currentIndex = 0;
  String _doctorName = 'Dr. Carlos Mendoza';
  String _doctorSpecialty = 'Pediatría';
  String _doctorCMP = 'CMP-45892';
  String _doctorId = 'doc_1';

  List<Appointment> _doctorAppointments = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDoctorData();
  }

  Future<void> _loadDoctorData() async {
    setState(() => _isLoading = true);
    final session = await _authUseCases.getUserSessionUseCase.run();
    if (session?.user != null) {
      _doctorName = 'Dr. ${session!.user.name} ${session.user.lastname}';
      if (session.user.specialty != null && session.user.specialty!.isNotEmpty) {
        _doctorSpecialty = session.user.specialty!;
      }
      if (session.user.cmp != null && session.user.cmp!.isNotEmpty) {
        _doctorCMP = session.user.cmp!;
      }
    }

    final res =
        await _appointmentsUseCases.getAppointments.run(doctorId: _doctorId);
    if (res is Success<List<Appointment>>) {
      _doctorAppointments = res.data;
    }
    setState(() => _isLoading = false);
  }

  void _openAttention(Appointment appointment) async {
    final updated = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => DoctorAttentionPage(appointment: appointment),
      ),
    );
    if (updated == true) {
      _loadDoctorData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final titles = [
      'Dashboard Médico',
      'Mis Citas de Pacientes',
      'Mi Horario',
      'Pacientes Atendidos',
      'Mi Perfil Profesional',
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(titles[_currentIndex]),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadDoctorData,
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: AppColors.primary),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.medical_services, size: 40, color: AppColors.primary),
              ),
              accountName: Text(_doctorName, style: const TextStyle(fontWeight: FontWeight.bold)),
              accountEmail: Text('$_doctorSpecialty • $_doctorCMP'),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard_outlined),
              title: const Text('Inicio'),
              selected: _currentIndex == 0,
              onTap: () {
                setState(() => _currentIndex = 0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.calendar_month_outlined),
              title: const Text('Mis citas'),
              selected: _currentIndex == 1,
              onTap: () {
                setState(() => _currentIndex = 1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.schedule),
              title: const Text('Mi horario'),
              selected: _currentIndex == 2,
              onTap: () {
                setState(() => _currentIndex = 2);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.people_outline),
              title: const Text('Pacientes'),
              selected: _currentIndex == 3,
              onTap: () {
                setState(() => _currentIndex = 3);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text('Mi perfil'),
              selected: _currentIndex == 4,
              onTap: () {
                setState(() => _currentIndex = 4);
                Navigator.pop(context);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: AppColors.error),
              title: const Text('Cerrar sesión', style: TextStyle(color: AppColors.error)),
              onTap: () async {
                await _authUseCases.logoutUseCase.run();
                if (!mounted) return;
                Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (_) => false);
              },
            ),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildCurrentBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (idx) => setState(() => _currentIndex = idx),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Citas'),
          BottomNavigationBarItem(icon: Icon(Icons.schedule), label: 'Horario'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Pacientes'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }

  Widget _buildCurrentBody() {
    switch (_currentIndex) {
      case 0:
        return _buildHomeDashboard();
      case 1:
        return _buildAppointmentsTab();
      case 2:
        return DoctorSchedulePage(doctorId: _doctorId);
      case 3:
        return _buildPatientsTab();
      case 4:
        return _buildProfileTab();
      default:
        return _buildHomeDashboard();
    }
  }

  // --- Tab 0: Inicio ---
  Widget _buildHomeDashboard() {
    final pendingApts = _doctorAppointments
        .where((a) =>
            a.status == AppointmentStatus.CONFIRMADA ||
            a.status == AppointmentStatus.PENDIENTE ||
            a.status == AppointmentStatus.REPROGRAMADA)
        .toList();
    final attendedApts = _doctorAppointments
        .where((a) => a.status == AppointmentStatus.ATENDIDA)
        .toList();
    final nextApt = pendingApts.isNotEmpty ? pendingApts.first : null;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Saludo
          Text('Buenos días, $_doctorName', style: AppTextStyles.screenTitle),
          const SizedBox(height: 4),
          Text('Especialidad: $_doctorSpecialty', style: AppTextStyles.body),
          const SizedBox(height: 20),

          // Tarjetas de Indicadores del Médico
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  title: 'Citas de hoy',
                  value: '${pendingApts.length + 2}',
                  icon: Icons.event_available,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _buildMetricCard(
                  title: 'Pacientes atendidos',
                  value: '${attendedApts.length + 5}',
                  icon: Icons.check_circle_outline,
                  color: AppColors.success,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Próxima Cita
          Text('Próxima Cita para Atender', style: AppTextStyles.sectionTitle),
          const SizedBox(height: 12),
          if (nextApt != null)
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.primary.withOpacity(0.3), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.access_time_filled, color: AppColors.primary, size: 20),
                          const SizedBox(width: 6),
                          Text(
                            nextApt.appointmentTime,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: nextApt.status.color.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          nextApt.status.displayName,
                          style: TextStyle(
                            color: nextApt.status.color,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 20),
                  Text('Paciente: ${nextApt.patientName}', style: AppTextStyles.cardTitle),
                  const SizedBox(height: 4),
                  Text('Especialidad: ${nextApt.doctorSpecialty}', style: AppTextStyles.body),
                  const SizedBox(height: 4),
                  Text('Motivo: ${nextApt.reason}', style: AppTextStyles.caption.copyWith(fontSize: 13)),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      icon: const Icon(Icons.medical_services_outlined, color: Colors.white),
                      label: const Text('Atender Cita Ahora', style: TextStyle(fontWeight: FontWeight.bold)),
                      onPressed: () => _openAttention(nextApt),
                    ),
                  ),
                ],
              ),
            )
          else
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Text('No tienes citas pendientes en este momento.'),
              ),
            ),

          const SizedBox(height: 24),

          // Acciones Rápidas
          Text('Accesos Rápidos', style: AppTextStyles.sectionTitle),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildQuickAction(
                  title: 'Mi Horario',
                  icon: Icons.alarm,
                  color: Colors.indigo,
                  onTap: () => setState(() => _currentIndex = 2),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickAction(
                  title: 'Ver Pacientes',
                  icon: Icons.groups,
                  color: AppColors.accent,
                  onTap: () => setState(() => _currentIndex = 3),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
          CircleAvatar(
            radius: 20,
            backgroundColor: color.withOpacity(0.12),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(title, style: AppTextStyles.caption.copyWith(fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildQuickAction({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.inputBorder.withOpacity(0.5)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          ],
        ),
      ),
    );
  }

  // --- Tab 1: Mis Citas de Pacientes ---
  Widget _buildAppointmentsTab() {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Container(
            color: Colors.white,
            child: const TabBar(
              labelColor: AppColors.primary,
              indicatorColor: AppColors.primary,
              tabs: [
                Tab(text: 'Pendientes / Confirmadas'),
                Tab(text: 'Atendidas'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildDoctorAppointmentsList(
                  _doctorAppointments
                      .where((a) =>
                          a.status == AppointmentStatus.CONFIRMADA ||
                          a.status == AppointmentStatus.PENDIENTE ||
                          a.status == AppointmentStatus.REPROGRAMADA)
                      .toList(),
                  showAttendButton: true,
                ),
                _buildDoctorAppointmentsList(
                  _doctorAppointments
                      .where((a) => a.status == AppointmentStatus.ATENDIDA)
                      .toList(),
                  showAttendButton: false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorAppointmentsList(
    List<Appointment> list, {
    required bool showAttendButton,
  }) {
    if (list.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.event_busy, size: 50, color: AppColors.textMuted),
            SizedBox(height: 12),
            Text('No hay citas en este estado.', style: AppTextStyles.body),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final apt = list[index];
        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 1.5,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${apt.appointmentDate.day}/${apt.appointmentDate.month}/${apt.appointmentDate.year} • ${apt.appointmentTime}',
                      style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: apt.status.color.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        apt.status.displayName,
                        style: TextStyle(
                          color: apt.status.color,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(),
                Text('Paciente: ${apt.patientName}', style: AppTextStyles.cardTitle),
                Text('Teléfono: ${apt.patientPhone}', style: AppTextStyles.caption),
                const SizedBox(height: 6),
                Text('Motivo: ${apt.reason}', style: AppTextStyles.body.copyWith(fontSize: 13)),
                if (apt.diagnosis != null) ...[
                  const SizedBox(height: 6),
                  Text('Diagnóstico: ${apt.diagnosis}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.success)),
                ],
                if (showAttendButton) ...[
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      icon: const Icon(Icons.edit_document, size: 16, color: Colors.white),
                      label: const Text('Atender Consulta'),
                      onPressed: () => _openAttention(apt),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  // --- Tab 3: Pacientes Atendidos ---
  Widget _buildPatientsTab() {
    final patients = [
      {'name': 'Josué Quiroz', 'dni': '74829103', 'phone': '+51 987 111 222', 'attentions': '2'},
      {'name': 'María Rodríguez', 'dni': '43920194', 'phone': '+51 992 334 556', 'attentions': '1'},
      {'name': 'Lucas Fernández', 'dni': '78294012', 'phone': '+51 945 667 889', 'attentions': '3'},
    ];

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: patients.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final p = patients[index];
        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 1,
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: AppColors.primarySoft,
              child: Icon(Icons.person, color: AppColors.primary),
            ),
            title: Text(p['name']!, style: AppTextStyles.cardTitle),
            subtitle: Text('DNI: ${p['dni']} • Tel: ${p['phone']}'),
            trailing: Chip(
              label: Text('${p['attentions']} atenciones'),
              backgroundColor: AppColors.primarySoft,
              labelStyle: const TextStyle(fontSize: 11, color: AppColors.primary),
            ),
          ),
        );
      },
    );
  }

  // --- Tab 4: Mi Perfil Profesional ---
  Widget _buildProfileTab() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Center(
          child: Column(
            children: [
              const CircleAvatar(
                radius: 45,
                backgroundColor: AppColors.primarySoft,
                child: Icon(Icons.person, size: 50, color: AppColors.primary),
              ),
              const SizedBox(height: 12),
              Text(_doctorName, style: AppTextStyles.screenTitle.copyWith(fontSize: 20)),
              Text(_doctorSpecialty, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
              Text('CMP: $_doctorCMP', style: AppTextStyles.caption),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.workspace_premium, color: AppColors.primary),
                title: const Text('Experiencia'),
                trailing: const Text('8 años', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.payments_outlined, color: AppColors.success),
                title: const Text('Costo de Consulta'),
                trailing: const Text('S/ 80.00', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.email_outlined, color: AppColors.primary),
                title: const Text('Correo'),
                subtitle: const Text('dr.mendoza@mediapp.com'),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.phone_outlined, color: AppColors.primary),
                title: const Text('Teléfono'),
                subtitle: const Text('+51 987 654 321'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
