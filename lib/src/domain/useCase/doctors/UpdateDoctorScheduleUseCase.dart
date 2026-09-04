import 'package:myfirstlove/src/domain/models/Schedule.dart';
import 'package:myfirstlove/src/domain/repository/DoctorsRepository.dart';
import 'package:myfirstlove/src/domain/utils/Resource.dart';

class UpdateDoctorScheduleUseCase {
  final DoctorsRepository repository;

  UpdateDoctorScheduleUseCase(this.repository);

  Future<Resource<bool>> run(DoctorSchedule schedule) {
    return repository.updateDoctorSchedule(schedule);
  }
}
