import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myfirstlove/injection.dart';
import 'package:myfirstlove/src/constants/app_colors.dart';
import 'package:myfirstlove/src/constants/app_text_styles.dart';
import 'package:myfirstlove/src/domain/models/Appointment.dart';
import 'package:myfirstlove/src/domain/models/Doctor.dart';
import 'package:myfirstlove/src/domain/models/Specialty.dart';
import 'package:myfirstlove/src/domain/useCase/appointments/AppointmentsUseCases.dart';
import 'package:myfirstlove/src/domain/useCase/doctors/DoctorsUseCases.dart';
import 'package:myfirstlove/src/domain/useCase/specialties/SpecialtiesUseCases.dart';
import 'package:myfirstlove/src/domain/utils/Resource.dart';
import 'package:myfirstlove/src/features/appointments/presentation/screens/book/BookAppointmentPage.dart';
import 'package:myfirstlove/src/features/appointments/presentation/screens/detail/AppointmentDetailPage.dart';
import 'package:myfirstlove/src/features/dashboard/presentation/screens/client/home/bloc/HomeClientBloc.dart';
import 'package:myfirstlove/src/features/dashboard/presentation/screens/client/home/bloc/HomeClientEvent.dart';
import 'package:myfirstlove/src/features/dashboard/presentation/screens/client/home/bloc/HomeClientState.dart';
import 'package:myfirstlove/src/features/medical_history/presentation/screens/MedicalHistoryPage.dart';
import 'package:myfirstlove/src/routing/app_router.dart';

class HomeClientPage extends StatefulWidget {
  const HomeClientPage({super.key});

  @override
  State<HomeClientPage> createState() => _HomeClientPageState();
}

class _HomeClientPageState extends State<HomeClientPage> {
  late HomeClientBloc _bloc;
  final SpecialtiesUseCases _specialtiesUseCases = locator<SpecialtiesUseCases>();
  final DoctorsUseCases _doctorsUseCases = locator<DoctorsUseCases>();
  final AppointmentsUseCases _appointmentsUseCases = locator<AppointmentsUseCases>();

  List<Specialty> _specialties = [];
  List<Doctor> _doctors = [];
  List<Appointment> _appointments = [];
  bool _isLoadingHome = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<HomeClientBloc>(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _bloc.add(const ProfileInfoGetUser());
      _loadHomeData();
    });
  }

  Future<void> _loadHomeData() async {
    setState(() => _isLoadingHome = true);
    final specRes = await _specialtiesUseCases.getSpecialties.run();
    if (specRes is Success<List<Specialty>>) {
      _specialties = specRes.data;
    }
    final docRes = await _doctorsUseCases.getDoctors.run();
    if (docRes is Success<List<Doctor>>) {
      _doctors = docRes.data;
    }
    final aptRes = await _appointmentsUseCases.getAppointments.run(patientId: '1');
    if (aptRes is Success<List<Appointment>>) {
      _appointments = aptRes.data;
    }
    setState(() => _isLoadingHome = false);
  }

  void _navigateToBooking({Specialty? specialty, Doctor? doctor}) async {
    final booked = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => BookAppointmentPage(
          initialSpecialty: specialty,
          initialDoctor: doctor,
        ),
      ),
    );
    if (booked == true) {
      _loadHomeData();
      _bloc.add(const ChangeDrawerPage(pageIndex: 1)); // Ir a Mis Citas
    }
  }

  void _openAppointmentDetail(Appointment appointment) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AppointmentDetailPage(appointment: appointment),
      ),
    );
    _loadHomeData();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeClientBloc, HomeClientState>(
      builder: (context, state) {
        final titles = [
          'MediApp — Paciente',
          'Mis Citas Médicas',
          'Historial Médico',
          'Mi Perfil',
        ];

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: Text(titles[state.pageIndex]),
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_none),
                onPressed: () {},
              ),
            ],
          ),
          drawer: _buildDrawer(state),
          body: _buildCurrentPage(state.pageIndex, state),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: state.pageIndex,
            onTap: (index) {
              _bloc.add(ChangeDrawerPage(pageIndex: index));
            },
            type: BottomNavigationBarType.fixed,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: AppColors.textSecondary,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Inicio'),
              BottomNavigationBarItem(icon: Icon(Icons.calendar_today_outlined), activeIcon: Icon(Icons.calendar_today), label: 'Mis Citas'),
              BottomNavigationBarItem(icon: Icon(Icons.history_outlined), activeIcon: Icon(Icons.history), label: 'Historial'),
              BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Perfil'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDrawer(HomeClientState state) {
    final userName = state.user != null ? '${state.user!.name} ${state.user!.lastname}' : 'Josué Quiroz';
    final userEmail = state.user?.email ?? 'paciente@mediapp.com';

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: AppColors.primary),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 40, color: AppColors.primary),
            ),
            accountName: Text(userName, style: const TextStyle(fontWeight: FontWeight.bold)),
            accountEmail: Text(userEmail),
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Inicio'),
            selected: state.pageIndex == 0,
            onTap: () {
              _bloc.add(const ChangeDrawerPage(pageIndex: 0));
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.add_circle_outline, color: AppColors.primary),
            title: const Text('Reservar Cita Médica', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
            onTap: () {
              Navigator.pop(context);
              _navigateToBooking();
            },
          ),
          ListTile(
            leading: const Icon(Icons.calendar_today_outlined),
            title: const Text('Mis citas'),
            selected: state.pageIndex == 1,
            onTap: () {
              _bloc.add(const ChangeDrawerPage(pageIndex: 1));
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.history_outlined),
            title: const Text('Historial médico'),
            selected: state.pageIndex == 2,
            onTap: () {
              _bloc.add(const ChangeDrawerPage(pageIndex: 2));
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text('Mi perfil'),
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

  Widget _buildCurrentPage(int index, HomeClientState state) {
    switch (index) {
      case 0:
        return _buildHomeTab(state);
      case 1:
        return _buildAppointmentsTab();
      case 2:
        return const MedicalHistoryPage();
      case 3:
        return _buildProfileTab(state);
      default:
        return _buildHomeTab(state);
    }
  }

  // --- TAB 0: INICIO ---
  Widget _buildHomeTab(HomeClientState state) {
    final patientName = state.user?.name ?? 'Josué';
    final upcomingApts = _appointments.where((a) =>
        a.status == AppointmentStatus.CONFIRMADA ||
        a.status == AppointmentStatus.PENDIENTE ||
        a.status == AppointmentStatus.REPROGRAMADA).toList();
    final nextApt = upcomingApts.isNotEmpty ? upcomingApts.first : null;

    final filteredDoctors = _searchQuery.isEmpty
        ? _doctors
        : _doctors.where((d) =>
            d.fullName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            d.specialtyName.toLowerCase().contains(_searchQuery.toLowerCase())).toList();

    return RefreshIndicator(
      onRefresh: _loadHomeData,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Saludo
            Text('Hola, $patientName 👋', style: AppTextStyles.screenTitle),
            const SizedBox(height: 4),
            Text('¿Qué atención médica necesitas hoy?', style: AppTextStyles.body),
            const SizedBox(height: 18),

            // Buscador de médico o especialidad
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                onChanged: (val) => setState(() => _searchQuery = val),
                decoration: InputDecoration(
                  hintText: 'Buscar médico o especialidad...',
                  prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Próxima Cita
            if (nextApt != null) ...[
              Text('Próxima Cita Programada', style: AppTextStyles.sectionTitle),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryLight],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.25),
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
                            const Icon(Icons.calendar_today, color: Colors.white, size: 16),
                            const SizedBox(width: 6),
                            Text(
                              '${nextApt.appointmentDate.day} de ${_getMonthName(nextApt.appointmentDate.month)}',
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            nextApt.appointmentTime,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                    const Divider(color: Colors.white24, height: 20),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundImage: NetworkImage(nextApt.doctorImage),
                          backgroundColor: Colors.white24,
                          child: nextApt.doctorImage.isEmpty
                              ? const Icon(Icons.person, color: Colors.white)
                              : null,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Dr. ${nextApt.doctorName}',
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              Text(
                                nextApt.doctorSpecialty,
                                style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => _openAppointmentDetail(nextApt),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                          child: const Text('Ver Cita', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Accesos Rápidos
            Text('Accesos Rápidos', style: AppTextStyles.sectionTitle),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildQuickActionCard(
                    title: 'Reservar Cita',
                    icon: Icons.add_circle,
                    color: AppColors.primary,
                    onTap: () => _navigateToBooking(),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildQuickActionCard(
                    title: 'Mis Citas',
                    icon: Icons.calendar_month,
                    color: AppColors.secondary,
                    onTap: () => _bloc.add(const ChangeDrawerPage(pageIndex: 1)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildQuickActionCard(
                    title: 'Historial',
                    icon: Icons.assignment_outlined,
                    color: AppColors.accent,
                    onTap: () => _bloc.add(const ChangeDrawerPage(pageIndex: 2)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildQuickActionCard(
                    title: 'Mi Perfil',
                    icon: Icons.account_circle_outlined,
                    color: Colors.deepPurple,
                    onTap: () => _bloc.add(const ChangeDrawerPage(pageIndex: 3)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 26),

            // Especialidades Médicas
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Especialidades', style: AppTextStyles.sectionTitle),
                TextButton(
                  onPressed: () => _navigateToBooking(),
                  child: const Text('Ver todas'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _buildSpecialtiesHorizontalList(),
            const SizedBox(height: 26),

            // Médicos Especialistas
            Text('Nuestros Médicos Especialistas', style: AppTextStyles.sectionTitle),
            const SizedBox(height: 12),
            ...filteredDoctors.map((doc) => _buildDoctorCard(doc)),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionCard({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.inputBorder.withOpacity(0.5)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: color.withOpacity(0.12),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecialtiesHorizontalList() {
    return SizedBox(
      height: 95,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _specialties.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final spec = _specialties[index];
          return InkWell(
            onTap: () => _navigateToBooking(specialty: spec),
            borderRadius: BorderRadius.circular(14),
            child: Container(
              width: 90,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.inputBorder.withOpacity(0.6)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: AppColors.primarySoft,
                    child: Icon(_getIconForSpecialty(spec.name), color: AppColors.primary, size: 22),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    spec.name,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDoctorCard(Doctor doc) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 1.5,
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 34,
              backgroundImage: NetworkImage(doc.image),
              backgroundColor: AppColors.primarySoft,
              child: doc.image.isEmpty
                  ? const Icon(Icons.person, color: AppColors.primary, size: 30)
                  : null,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(doc.fullName, style: AppTextStyles.cardTitle),
                  const SizedBox(height: 2),
                  Text(doc.specialtyName, style: const TextStyle(color: AppColors.primary, fontSize: 13, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text('Experiencia: ${doc.experienceYears} años', style: AppTextStyles.caption),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        'S/ ${doc.consultationFee.toInt()}',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.textPrimary),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.star, color: Colors.amber, size: 14),
                      Text(' ${doc.rating} (${doc.reviewsCount})', style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () => _navigateToBooking(doctor: doc),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Disponibilidad', style: TextStyle(fontSize: 12)),
            ),
          ],
        ),
      ),
    );
  }

  // --- TAB 1: MIS CITAS ---
  Widget _buildAppointmentsTab() {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          Container(
            color: Colors.white,
            child: const TabBar(
              labelColor: AppColors.primary,
              indicatorColor: AppColors.primary,
              tabs: [
                Tab(text: 'Próximas'),
                Tab(text: 'Historial'),
                Tab(text: 'Canceladas'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildAppointmentsList(
                  _appointments.where((a) =>
                      a.status == AppointmentStatus.CONFIRMADA ||
                      a.status == AppointmentStatus.PENDIENTE ||
                      a.status == AppointmentStatus.REPROGRAMADA).toList(),
                  showCancel: true,
                ),
                _buildAppointmentsList(
                  _appointments.where((a) => a.status == AppointmentStatus.ATENDIDA).toList(),
                  showCancel: false,
                ),
                _buildAppointmentsList(
                  _appointments.where((a) => a.status == AppointmentStatus.CANCELADA).toList(),
                  showCancel: false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentsList(List<Appointment> list, {required bool showCancel}) {
    if (list.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.calendar_month_outlined, size: 60, color: AppColors.textMuted),
              const SizedBox(height: 16),
              const Text('No tienes citas en esta sección.', style: AppTextStyles.body),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => _navigateToBooking(),
                icon: const Icon(Icons.add),
                label: const Text('Reservar Cita Ahora'),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      separatorBuilder: (_, __) => const SizedBox(height: 14),
      itemBuilder: (context, index) {
        final apt = list[index];
        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                      '${apt.appointmentDate.day} de ${_getMonthName(apt.appointmentDate.month)} • ${apt.appointmentTime}',
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
                const Divider(height: 20),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundImage: NetworkImage(apt.doctorImage),
                      backgroundColor: AppColors.primarySoft,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Dr. ${apt.doctorName}', style: AppTextStyles.cardTitle),
                          Text(apt.doctorSpecialty, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: () => _openAppointmentDetail(apt),
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Ver detalle'),
                    ),
                    if (showCancel) ...[
                      const SizedBox(width: 8),
                      TextButton(
                        onPressed: () => _openAppointmentDetail(apt),
                        style: TextButton.styleFrom(foregroundColor: AppColors.error),
                        child: const Text('Cancelar'),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // --- TAB 3: MI PERFIL ---
  Widget _buildProfileTab(HomeClientState state) {
    final user = state.user;
    final name = user?.name ?? 'Josué';
    final lastname = user?.lastname ?? 'Quiroz';
    final email = user?.email ?? 'paciente@mediapp.com';
    final phone = user?.phone ?? '+51 987 111 222';
    final dni = user?.dni ?? '74829103';
    final birthDate = user?.birthDate ?? '15/04/1996';
    final gender = user?.gender ?? 'Masculino';
    final address = user?.address ?? 'Av. Javier Prado Este 1420, Lima';

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Center(
          child: Column(
            children: [
              const CircleAvatar(
                radius: 46,
                backgroundColor: AppColors.primarySoft,
                child: Icon(Icons.person, size: 54, color: AppColors.primary),
              ),
              const SizedBox(height: 12),
              Text('$name $lastname', style: AppTextStyles.screenTitle.copyWith(fontSize: 20)),
              Text('Paciente Registrado', style: AppTextStyles.caption),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          child: Column(
            children: [
              _buildProfileRow(Icons.badge_outlined, 'DNI', dni),
              const Divider(height: 1),
              _buildProfileRow(Icons.cake_outlined, 'Fecha de nacimiento', birthDate),
              const Divider(height: 1),
              _buildProfileRow(Icons.male, 'Sexo', gender),
              const Divider(height: 1),
              _buildProfileRow(Icons.phone_outlined, 'Teléfono', phone),
              const Divider(height: 1),
              _buildProfileRow(Icons.email_outlined, 'Correo', email),
              const Divider(height: 1),
              _buildProfileRow(Icons.location_on_outlined, 'Dirección', address),
            ],
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              if (user != null) {
                Navigator.pushNamed(context, AppRoutes.updateUser, arguments: user);
              }
            },
            icon: const Icon(Icons.edit, size: 18),
            label: const Text('Actualizar Datos Personales'),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileRow(IconData icon, String label, String value) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
      subtitle: Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
    );
  }

  IconData _getIconForSpecialty(String name) {
    switch (name.toLowerCase()) {
      case 'medicina general':
        return Icons.medical_services_outlined;
      case 'pediatría':
        return Icons.child_care;
      case 'cardiología':
        return Icons.favorite;
      case 'dermatología':
        return Icons.spa;
      case 'ginecología':
        return Icons.pregnant_woman;
      case 'traumatología':
        return Icons.healing;
      case 'oftalmología':
        return Icons.visibility;
      case 'neurología':
        return Icons.psychology;
      case 'odontología':
        return Icons.sentiment_very_satisfied;
      case 'psicología':
        return Icons.self_improvement;
      default:
        return Icons.local_hospital;
    }
  }

  String _getMonthName(int month) {
    const months = [
      'enero',
      'febrero',
      'marzo',
      'abril',
      'mayo',
      'junio',
      'julio',
      'agosto',
      'septiembre',
      'octubre',
      'noviembre',
      'diciembre'
    ];
    return months[month - 1];
  }
}
