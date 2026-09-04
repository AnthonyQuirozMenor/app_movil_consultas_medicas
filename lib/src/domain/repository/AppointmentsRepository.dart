import 'package:myfirstlove/src/domain/models/Appointment.dart';
import 'package:myfirstlove/src/domain/utils/Resource.dart';

abstract class AppointmentsRepository {
  Future<Resource<List<Appointment>>> getAppointments({
    String? patientId,
    String? doctorId,
  });
  Future<Resource<List<String>>> getAvailableSlots(
    String doctorId,
    DateTime date,
  );
  Future<Resource<Appointment>> createAppointment(Appointment appointment);
  Future<Resource<bool>> cancelAppointment(String appointmentId);
  Future<Resource<bool>> rescheduleAppointment(
    String appointmentId,
    DateTime newDate,
    String newTime,
  );
  Future<Resource<bool>> attendAppointment({
    required String appointmentId,
    required String diagnosis,
    required String treatment,
    required String observations,
  });
}
