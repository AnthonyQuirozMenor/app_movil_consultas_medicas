import 'package:myfirstlove/src/data/dataSource/remote/service/AppointmentsService.dart';
import 'package:myfirstlove/src/domain/models/Appointment.dart';
import 'package:myfirstlove/src/domain/repository/AppointmentsRepository.dart';
import 'package:myfirstlove/src/domain/utils/Resource.dart';

class AppointmentsRepositoryImpl implements AppointmentsRepository {
  final AppointmentsService appointmentsService;

  AppointmentsRepositoryImpl(this.appointmentsService);

  @override
  Future<Resource<List<Appointment>>> getAppointments({
    String? patientId,
    String? doctorId,
  }) {
    return appointmentsService.getAppointments(
      patientId: patientId,
      doctorId: doctorId,
    );
  }

  @override
  Future<Resource<List<String>>> getAvailableSlots(
    String doctorId,
    DateTime date,
  ) {
    return appointmentsService.getAvailableSlots(doctorId, date);
  }

  @override
  Future<Resource<Appointment>> createAppointment(Appointment appointment) {
    return appointmentsService.createAppointment(appointment);
  }

  @override
  Future<Resource<bool>> cancelAppointment(String appointmentId) {
    return appointmentsService.cancelAppointment(appointmentId);
  }

  @override
  Future<Resource<bool>> rescheduleAppointment(
    String appointmentId,
    DateTime newDate,
    String newTime,
  ) {
    return appointmentsService.rescheduleAppointment(
      appointmentId,
      newDate,
      newTime,
    );
  }

  @override
  Future<Resource<bool>> attendAppointment({
    required String appointmentId,
    required String diagnosis,
    required String treatment,
    required String observations,
  }) {
    return appointmentsService.attendAppointment(
      appointmentId: appointmentId,
      diagnosis: diagnosis,
      treatment: treatment,
      observations: observations,
    );
  }
}
