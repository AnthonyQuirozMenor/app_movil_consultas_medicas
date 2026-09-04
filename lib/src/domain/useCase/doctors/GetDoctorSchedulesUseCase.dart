import 'package:myfirstlove/src/domain/models/Schedule.dart';
import 'package:myfirstlove/src/domain/repository/DoctorsRepository.dart';
import 'package:myfirstlove/src/domain/utils/Resource.dart';

class GetDoctorSchedulesUseCase {
  final DoctorsRepository repository;

  GetDoctorSchedulesUseCase(this.repository);

  Future<Resource<List<DoctorSchedule>>> run(String doctorId) {
    return repository.getDoctorSchedules(doctorId);
  }
}
