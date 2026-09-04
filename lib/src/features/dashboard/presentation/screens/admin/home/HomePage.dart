import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:myfirstlove/injection.dart';
import 'package:myfirstlove/src/constants/app_colors.dart';
import 'package:myfirstlove/src/constants/app_text_styles.dart';
import 'package:myfirstlove/src/data/dataSource/local/MedicalLocalStore.dart';
import 'package:myfirstlove/src/domain/models/Appointment.dart';
import 'package:myfirstlove/src/domain/models/Doctor.dart';
import 'package:myfirstlove/src/domain/models/Specialty.dart';
import 'package:myfirstlove/src/features/appointments/presentation/screens/detail/AppointmentDetailPage.dart';
import 'package:myfirstlove/src/features/dashboard/presentation/screens/admin/home/bloc/HomeBloc.dart';
import 'package:myfirstlove/src/features/dashboard/presentation/screens/admin/home/bloc/HomeEvent.dart';
import 'package:myfirstlove/src/features/dashboard/presentation/screens/admin/home/bloc/HomeState.dart';
import 'package:myfirstlove/src/routing/app_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomeBloc _bloc;
  final MedicalLocalStore _localStore = MedicalLocalStore();

  late Map<String, int> _metrics;
  late List<Doctor> _doctors;
  late List<Specialty> _specialties;
  late List<Appointment> _appointments;

  final Map<int, String> _pageTitles = {
    0: 'Panel de Administración Clínica',
    1: 'Gestión de Médicos',
    2: 'Especialidades Médicas',
    3: 'Gestión de Citas',
  };

  @override
  void initState() {
    super.initState();
    _refreshAdminData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _bloc = BlocProvider.of<HomeBloc>(context);
      _bloc.add(const ProfileInfoGetUser());
    });
  }

  void _refreshAdminData() {
    setState(() {
      _metrics = _localStore.getAdminMetrics();
      _doctors = _localStore.getDoctors();
      _specialties = _localStore.getSpecialties();
      _appointments = _localStore.getAppointments();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: Text(
              _pageTitles[state.pageIndex] ?? 'Administración',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            backgroundColor: AppColors.primary_admin,
            iconTheme: const IconThemeData(color: Colors.white),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: _refreshAdminData,
              ),
            ],
          ),
          drawer: _buildAdminDrawer(state),
          body: _buildCurrentAdminTab(state.pageIndex),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: state.pageIndex,
            onTap: (index) {
              _bloc.add(ChangeDrawerPage(pageIndex: index));
            },
            type: BottomNavigationBarType.fixed,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: Colors.grey,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined), activeIcon: Icon(Icons.dashboard), label: 'Dashboard'),
              BottomNavigationBarItem(icon: Icon(Icons.medical_services_outlined), activeIcon: Icon(Icons.medical_services), label: 'Médicos'),
              BottomNavigationBarItem(icon: Icon(Icons.category_outlined), activeIcon: Icon(Icons.category), label: 'Especialidades'),
              BottomNavigationBarItem(icon: Icon(Icons.calendar_month_outlined), activeIcon: Icon(Icons.calendar_month), label: 'Citas'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAdminDrawer(HomeState state) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: AppColors.primary_admin),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundColor: Colors.white24,
                      child: const Icon(Icons.admin_panel_settings, size: 40, color: Colors.white),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: InkWell(
                        onTap: () {
                          if (state.user != null) {
                            Navigator.pushNamed(context, AppRoutes.updateUser, arguments: state.user);
                          }
                        },
                        child: Container(
                          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                          padding: const EdgeInsets.all(4),
                          child: const Icon(Icons.edit, color: AppColors.primary, size: 16),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '${state.user?.name ?? 'Admin'} ${state.user?.lastname ?? 'MediApp'}',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const Text(
                  'Rol: ADMINISTRADOR',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard_outlined),
            title: const Text('Dashboard'),
            selected: state.pageIndex == 0,
            onTap: () {
              _bloc.add(const ChangeDrawerPage(pageIndex: 0));
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.medical_services_outlined),
            title: const Text('Médicos'),
            selected: state.pageIndex == 1,
            onTap: () {
              _bloc.add(const ChangeDrawerPage(pageIndex: 1));
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.category_outlined),
            title: const Text('Especialidades'),
            selected: state.pageIndex == 2,
            onTap: () {
              _bloc.add(const ChangeDrawerPage(pageIndex: 2));
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.calendar_month_outlined),
            title: const Text('Citas Médicas'),
            selected: state.pageIndex == 3,
            onTap: () {
              _bloc.add(const ChangeDrawerPage(pageIndex: 3));
              Navigator.pop(context);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: AppColors.error),
            title: const Text('Cerrar sesión', style: TextStyle(color: AppColors.error)),
            onTap: () {
              _bloc.add(const Logout());
              Navigator.pushReplacementNamed(context, AppRoutes.login);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentAdminTab(int pageIndex) {
    switch (pageIndex) {
      case 0:
        return _buildDashboardKPIs();
      case 1:
        return _buildDoctorsManagement();
      case 2:
        return _buildSpecialtiesManagement();
      case 3:
        return _buildAppointmentsManagement();
      default:
        return _buildDashboardKPIs();
    }
  }

  // --- TAB 0: DASHBOARD KPIS ---
  Widget _buildDashboardKPIs() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Indicadores Clínicos del Sistema', style: AppTextStyles.sectionTitle),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildKPICard(
                  title: 'Pacientes registrados',
                  value: '${_metrics['patients']}',
                  icon: Icons.people_alt_outlined,
                  color: Colors.blue.shade700,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _buildKPICard(
                  title: 'Médicos registrados',
                  value: '${_metrics['doctors']}',
                  icon: Icons.medical_services_outlined,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _buildKPICard(
                  title: 'Citas de hoy',
                  value: '${_metrics['today']}',
                  icon: Icons.calendar_today,
                  color: Colors.orange.shade700,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _buildKPICard(
                  title: 'Citas atendidas',
                  value: '${_metrics['attended']}',
                  icon: Icons.verified,
                  color: AppColors.success,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _buildKPICard(
            title: 'Citas pendientes / confirmadas',
            value: '${_metrics['pending']}',
            icon: Icons.access_time,
            color: AppColors.statusPending,
          ),
          const SizedBox(height: 28),

          // Resumen de Citas Recientes
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Últimas Citas Registradas', style: AppTextStyles.sectionTitle),
              TextButton(
                onPressed: () => _bloc.add(const ChangeDrawerPage(pageIndex: 3)),
                child: const Text('Ver todas'),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ..._appointments.take(4).map((apt) => Card(
                margin: const EdgeInsets.only(bottom: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: apt.status.color.withOpacity(0.12),
                    child: Icon(apt.status.icon, color: apt.status.color, size: 20),
                  ),
                  title: Text(apt.patientName, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('${apt.doctorSpecialty} • Dr. ${apt.doctorName}'),
                  trailing: Text(
                    apt.status.displayName,
                    style: TextStyle(color: apt.status.color, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => AppointmentDetailPage(appointment: apt)),
                    ).then((_) => _refreshAdminData());
                  },
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildKPICard({
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
        border: Border.all(color: AppColors.inputBorder.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
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
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(title, style: AppTextStyles.caption.copyWith(fontSize: 12)),
        ],
      ),
    );
  }

  // --- TAB 1: GESTIÓN DE MÉDICOS ---
  Widget _buildDoctorsManagement() {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _doctors.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final doc = _doctors[index];
        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(doc.image),
                  backgroundColor: AppColors.primarySoft,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(doc.fullName, style: AppTextStyles.cardTitle),
                      Text(doc.specialtyName, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                      Text('${doc.cmp} • ${doc.experienceYears} años exp.', style: AppTextStyles.caption),
                      Text('Tarifa: S/ ${doc.consultationFee.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
                Chip(
                  label: const Text('Activo'),
                  backgroundColor: Colors.green.shade50,
                  labelStyle: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 11),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // --- TAB 2: ESPECIALIDADES MÉDICAS ---
  Widget _buildSpecialtiesManagement() {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _specialties.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final spec = _specialties[index];
        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.primarySoft,
              child: const Icon(Icons.local_hospital, color: AppColors.primary),
            ),
            title: Text(spec.name, style: AppTextStyles.cardTitle),
            subtitle: Text(spec.description, maxLines: 2, overflow: TextOverflow.ellipsis),
            trailing: Text('S/ ${spec.basePrice.toInt()}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          ),
        );
      },
    );
  }

  // --- TAB 3: GESTIÓN DE CITAS ---
  Widget _buildAppointmentsManagement() {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _appointments.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final apt = _appointments[index];
        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: apt.status.color.withOpacity(0.12),
              child: Icon(apt.status.icon, color: apt.status.color),
            ),
            title: Text('${apt.patientName} (${apt.doctorSpecialty})', style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('Dr. ${apt.doctorName} • ${apt.appointmentDate.day}/${apt.appointmentDate.month} ${apt.appointmentTime}'),
            trailing: Chip(
              label: Text(apt.status.displayName),
              backgroundColor: apt.status.color.withOpacity(0.12),
              labelStyle: TextStyle(color: apt.status.color, fontWeight: FontWeight.bold, fontSize: 11),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AppointmentDetailPage(appointment: apt)),
              ).then((_) => _refreshAdminData());
            },
          ),
        );
      },
    );
  }
}