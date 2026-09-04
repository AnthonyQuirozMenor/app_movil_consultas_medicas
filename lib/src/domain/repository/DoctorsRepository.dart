import 'package:myfirstlove/src/domain/models/Doctor.dart';
import 'package:myfirstlove/src/domain/models/Schedule.dart';
import 'package:myfirstlove/src/domain/utils/Resource.dart';

abstract class DoctorsRepository {
  Future<Resource<List<Doctor>>> getDoctors({String? specialtyId});
  Future<Resource<Doctor>> getDoctorById(String id);
  Future<Resource<List<DoctorSchedule>>> getDoctorSchedules(String doctorId);
  Future<Resource<bool>> updateDoctorSchedule(DoctorSchedule schedule);
}
