import 'package:flutter/material.dart';
import 'package:myfirstlove/src/domain/models/Appointment.dart';
import 'package:myfirstlove/src/domain/models/Doctor.dart';
import 'package:myfirstlove/src/domain/models/Specialty.dart';
import 'package:myfirstlove/src/features/appointments/presentation/screens/book/BookAppointmentPage.dart';
import 'package:myfirstlove/src/features/appointments/presentation/screens/detail/AppointmentDetailPage.dart';
import 'package:myfirstlove/src/features/auth/presentation/screens/login/LoginPage.dart';
import 'package:myfirstlove/src/features/auth/presentation/screens/register/RegisterPage.dart';
import 'package:myfirstlove/src/features/auth/presentation/screens/welcome_screen.dart';
import 'package:myfirstlove/src/features/dashboard/presentation/screens/admin/amenities/create/AdminAmenityCreatePage.dart';
import 'package:myfirstlove/src/features/dashboard/presentation/screens/admin/home/HomePage.dart';
import 'package:myfirstlove/src/features/dashboard/presentation/screens/client/home/HomeClientPage.dart';
import 'package:myfirstlove/src/features/dashboard/presentation/screens/profile/update/ProfileUpdatePage.dart';
import 'package:myfirstlove/src/features/dashboard/presentation/screens/roles/RolesPage.dart';
import 'package:myfirstlove/src/features/doctor/presentation/screens/attention/DoctorAttentionPage.dart';
import 'package:myfirstlove/src/features/doctor/presentation/screens/home/DoctorHomePage.dart';
import 'package:myfirstlove/src/features/medical_history/presentation/screens/MedicalHistoryPage.dart';

class AppRoutes {
  static const String welcome = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String homeAdmin = 'admin/home';
  static const String homeClient = 'cliente/home';
  static const String homeDoctor = 'doctor/home';
  static const String role = '/roles';
  static const String bookAppointment = '/appointment/book';
  static const String appointmentDetail = '/appointment/detail';
  static const String doctorAttention = '/doctor/attention';
  static const String patientHistory = '/patient/history';
  static const String adminAmenitiesCreate = 'admin/amenities/create';
  static const String updateUser = '/profile/update';
}

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.welcome:
        return MaterialPageRoute(builder: (_) => const WelcomeScreen());
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case AppRoutes.register:
        return MaterialPageRoute(builder: (_) => const RegisterPage());
      case AppRoutes.homeAdmin:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case AppRoutes.homeClient:
        return MaterialPageRoute(builder: (_) => const HomeClientPage());
      case AppRoutes.homeDoctor:
        return MaterialPageRoute(builder: (_) => const DoctorHomePage());
      case AppRoutes.role:
        return MaterialPageRoute(builder: (_) => const RolesPage());
      case AppRoutes.bookAppointment:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => BookAppointmentPage(
            initialSpecialty: args?['specialty'] as Specialty?,
            initialDoctor: args?['doctor'] as Doctor?,
          ),
          settings: settings,
        );
      case AppRoutes.appointmentDetail:
        final apt = settings.arguments as Appointment;
        return MaterialPageRoute(
          builder: (_) => AppointmentDetailPage(appointment: apt),
          settings: settings,
        );
      case AppRoutes.doctorAttention:
        final apt = settings.arguments as Appointment;
        return MaterialPageRoute(
          builder: (_) => DoctorAttentionPage(appointment: apt),
          settings: settings,
        );
      case AppRoutes.patientHistory:
        return MaterialPageRoute(
          builder: (_) => const MedicalHistoryPage(isStandalone: true),
          settings: settings,
        );
      case AppRoutes.adminAmenitiesCreate:
        return MaterialPageRoute(
          builder: (_) => const AdminAmenityCreatePage(),
        );
      case AppRoutes.updateUser:
        return MaterialPageRoute(
          builder: (_) => const ProfileUpdatePage(),
          settings: settings,
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
