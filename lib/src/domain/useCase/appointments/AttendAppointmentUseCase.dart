import 'package:myfirstlove/src/domain/repository/AppointmentsRepository.dart';
import 'package:myfirstlove/src/domain/utils/Resource.dart';

class AttendAppointmentUseCase {
  final AppointmentsRepository repository;

  AttendAppointmentUseCase(this.repository);

  Future<Resource<bool>> run({
    required String appointmentId,
    required String diagnosis,
    required String treatment,
    required String observations,
  }) {
    return repository.attendAppointment(
      appointmentId: appointmentId,
      diagnosis: diagnosis,
      treatment: treatment,
      observations: observations,
    );
  }
}
