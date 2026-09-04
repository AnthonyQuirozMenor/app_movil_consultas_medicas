import 'package:myfirstlove/src/domain/repository/AppointmentsRepository.dart';
import 'package:myfirstlove/src/domain/utils/Resource.dart';

class CancelAppointmentUseCase {
  final AppointmentsRepository repository;

  CancelAppointmentUseCase(this.repository);

  Future<Resource<bool>> run(String appointmentId) {
    return repository.cancelAppointment(appointmentId);
  }
}
