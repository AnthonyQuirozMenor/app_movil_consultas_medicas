import 'package:myfirstlove/src/domain/models/Appointment.dart';
import 'package:myfirstlove/src/domain/repository/AppointmentsRepository.dart';
import 'package:myfirstlove/src/domain/utils/Resource.dart';

class GetAppointmentsUseCase {
  final AppointmentsRepository repository;

  GetAppointmentsUseCase(this.repository);

  Future<Resource<List<Appointment>>> run({
    String? patientId,
    String? doctorId,
  }) {
    return repository.getAppointments(
      patientId: patientId,
      doctorId: doctorId,
    );
  }
}
