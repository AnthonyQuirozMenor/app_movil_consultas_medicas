import 'package:myfirstlove/src/domain/repository/AppointmentsRepository.dart';
import 'package:myfirstlove/src/domain/utils/Resource.dart';

class GetAvailableSlotsUseCase {
  final AppointmentsRepository repository;

  GetAvailableSlotsUseCase(this.repository);

  Future<Resource<List<String>>> run(String doctorId, DateTime date) {
    return repository.getAvailableSlots(doctorId, date);
  }
}
