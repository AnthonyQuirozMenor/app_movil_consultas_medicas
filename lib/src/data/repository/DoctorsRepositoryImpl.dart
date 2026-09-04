import 'package:myfirstlove/src/data/dataSource/remote/service/DoctorsService.dart';
import 'package:myfirstlove/src/domain/models/Doctor.dart';
import 'package:myfirstlove/src/domain/models/Schedule.dart';
import 'package:myfirstlove/src/domain/repository/DoctorsRepository.dart';
import 'package:myfirstlove/src/domain/utils/Resource.dart';

class DoctorsRepositoryImpl implements DoctorsRepository {
  final DoctorsService doctorsService;

  DoctorsRepositoryImpl(this.doctorsService);

  @override
  Future<Resource<List<Doctor>>> getDoctors({String? specialtyId}) {
    return doctorsService.getDoctors(specialtyId: specialtyId);
  }

  @override
  Future<Resource<Doctor>> getDoctorById(String id) {
    return doctorsService.getDoctorById(id);
  }

  @override
  Future<Resource<List<DoctorSchedule>>> getDoctorSchedules(String doctorId) {
    return doctorsService.getDoctorSchedules(doctorId);
  }

  @override
  Future<Resource<bool>> updateDoctorSchedule(DoctorSchedule schedule) {
    return doctorsService.updateDoctorSchedule(schedule);
  }
}
