import 'package:myfirstlove/src/domain/repository/AppointmentsRepository.dart';
import 'package:myfirstlove/src/domain/utils/Resource.dart';

class RescheduleAppointmentUseCase {
  final AppointmentsRepository repository;

  RescheduleAppointmentUseCase(this.repository);

  Future<Resource<bool>> run(
    String appointmentId,
    DateTime newDate,
    String newTime,
  ) {
    return repository.rescheduleAppointment(
      appointmentId,
      newDate,
      newTime,
    );
  }
}
