import 'package:myfirstlove/src/domain/useCase/doctors/GetDoctorByIdUseCase.dart';
import 'package:myfirstlove/src/domain/useCase/doctors/GetDoctorSchedulesUseCase.dart';
import 'package:myfirstlove/src/domain/useCase/doctors/GetDoctorsUseCase.dart';
import 'package:myfirstlove/src/domain/useCase/doctors/UpdateDoctorScheduleUseCase.dart';

class DoctorsUseCases {
  final GetDoctorsUseCase getDoctors;
  final GetDoctorByIdUseCase getDoctorById;
  final GetDoctorSchedulesUseCase getDoctorSchedules;
  final UpdateDoctorScheduleUseCase updateDoctorSchedule;

  DoctorsUseCases({
    required this.getDoctors,
    required this.getDoctorById,
    required this.getDoctorSchedules,
    required this.updateDoctorSchedule,
  });
}
