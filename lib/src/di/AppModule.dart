import 'package:injectable/injectable.dart';
import 'package:myfirstlove/src/data/dataSource/local/SharedPref.dart';
import 'package:myfirstlove/src/data/dataSource/remote/service/AmenitiesService.dart';
import 'package:myfirstlove/src/data/dataSource/remote/service/AppointmentsService.dart';
import 'package:myfirstlove/src/data/dataSource/remote/service/AuthService.dart';
import 'package:myfirstlove/src/data/dataSource/remote/service/DoctorsService.dart';
import 'package:myfirstlove/src/data/dataSource/remote/service/MedicalHistoryService.dart';
import 'package:myfirstlove/src/data/dataSource/remote/service/SpecialtiesService.dart';
import 'package:myfirstlove/src/data/dataSource/remote/service/UsersService.dart';
import 'package:myfirstlove/src/data/repository/AmenitiesRepositoryimpl.dart';
import 'package:myfirstlove/src/data/repository/AppointmentsRepositoryImpl.dart';
import 'package:myfirstlove/src/data/repository/AuthRepositoryImpl.dart';
import 'package:myfirstlove/src/data/repository/DoctorsRepositoryImpl.dart';
import 'package:myfirstlove/src/data/repository/MedicalHistoryRepositoryImpl.dart';
import 'package:myfirstlove/src/data/repository/SpecialtiesRepositoryImpl.dart';
import 'package:myfirstlove/src/data/repository/UsersRepositoryImpl.dart';
import 'package:myfirstlove/src/domain/models/AuthResponse.dart';
import 'package:myfirstlove/src/domain/repository/AmenitiesRepository.dart';
import 'package:myfirstlove/src/domain/repository/AppointmentsRepository.dart';
import 'package:myfirstlove/src/domain/repository/AuthRepository.dart';
import 'package:myfirstlove/src/domain/repository/DoctorsRepository.dart';
import 'package:myfirstlove/src/domain/repository/MedicalHistoryRepository.dart';
import 'package:myfirstlove/src/domain/repository/SpecialtiesRepository.dart';
import 'package:myfirstlove/src/domain/repository/UsersRepository.dart';
import 'package:myfirstlove/src/domain/useCase/Amenities/AmenitiesUseCases.dart';
import 'package:myfirstlove/src/domain/useCase/Amenities/CreateAmenitiesUseCase.dart';
import 'package:myfirstlove/src/domain/useCase/Amenities/DeleteAmenitiesUseCase.dart';
import 'package:myfirstlove/src/domain/useCase/Amenities/GetAmenitiesUseCase.dart';
import 'package:myfirstlove/src/domain/useCase/Amenities/UpdateAmenitiesUseCase.dart';
import 'package:myfirstlove/src/domain/useCase/Auth/AuthUseCases.dart';
import 'package:myfirstlove/src/domain/useCase/Auth/GetUserSessionUseCase.dart';
import 'package:myfirstlove/src/domain/useCase/Auth/LoginUseCase.dart';
import 'package:myfirstlove/src/domain/useCase/Auth/LogoutUseCase.dart';
import 'package:myfirstlove/src/domain/useCase/Auth/RegisterUseCase.dart';
import 'package:myfirstlove/src/domain/useCase/Auth/SaveUserSessionUseCase.dart';
import 'package:myfirstlove/src/domain/useCase/appointments/AppointmentsUseCases.dart';
import 'package:myfirstlove/src/domain/useCase/appointments/AttendAppointmentUseCase.dart';
import 'package:myfirstlove/src/domain/useCase/appointments/CancelAppointmentUseCase.dart';
import 'package:myfirstlove/src/domain/useCase/appointments/CreateAppointmentUseCase.dart';
import 'package:myfirstlove/src/domain/useCase/appointments/GetAppointmentsUseCase.dart';
import 'package:myfirstlove/src/domain/useCase/appointments/GetAvailableSlotsUseCase.dart';
import 'package:myfirstlove/src/domain/useCase/appointments/RescheduleAppointmentUseCase.dart';
import 'package:myfirstlove/src/domain/useCase/doctors/DoctorsUseCases.dart';
import 'package:myfirstlove/src/domain/useCase/doctors/GetDoctorByIdUseCase.dart';
import 'package:myfirstlove/src/domain/useCase/doctors/GetDoctorSchedulesUseCase.dart';
import 'package:myfirstlove/src/domain/useCase/doctors/GetDoctorsUseCase.dart';
import 'package:myfirstlove/src/domain/useCase/doctors/UpdateDoctorScheduleUseCase.dart';
import 'package:myfirstlove/src/domain/useCase/medicalHistory/GetMedicalHistoryUseCase.dart';
import 'package:myfirstlove/src/domain/useCase/medicalHistory/MedicalHistoryUseCases.dart';
import 'package:myfirstlove/src/domain/useCase/specialties/GetSpecialtiesUseCase.dart';
import 'package:myfirstlove/src/domain/useCase/specialties/SpecialtiesUseCases.dart';
import 'package:myfirstlove/src/domain/useCase/users/UpdateUserUseCase.dart';
import 'package:myfirstlove/src/domain/useCase/users/UsersUseCases.dart';

@module
abstract class AppModule {
  // Shared Preferences
  @injectable
  SharedPref get sharedPref => SharedPref();

  @injectable
  Future<String> get token async {
    String token = "";
    final userSession = await sharedPref.read('user');
    if (userSession != null) {
      AuthResponse authResponse = AuthResponse.fromJson(userSession);
      token = authResponse.token;
    }
    return token;
  }

  // Services
  @injectable
  AuthService get authService => AuthService();

  @injectable
  UsersService get usersService => UsersService(token);

  @injectable
  AmenitiesService get amenitiesService => AmenitiesService(token);

  @injectable
  SpecialtiesService get specialtiesService => SpecialtiesService(token);

  @injectable
  DoctorsService get doctorsService => DoctorsService(token);

  @injectable
  AppointmentsService get appointmentsService => AppointmentsService(token);

  @injectable
  MedicalHistoryService get medicalHistoryService =>
      MedicalHistoryService(token);

  // Repositories
  @injectable
  AuthRepository get authRepository =>
      AuthRepositoryImpl(authService, sharedPref);

  @injectable
  UsersRepository get usersRepository => UsersRepositoryImpl(usersService);

  @injectable
  AmenitiesRepository get amenitiesRepository =>
      AmenitiesRepositoryimpl(amenitiesService);

  @injectable
  SpecialtiesRepository get specialtiesRepository =>
      SpecialtiesRepositoryImpl(specialtiesService);

  @injectable
  DoctorsRepository get doctorsRepository =>
      DoctorsRepositoryImpl(doctorsService);

  @injectable
  AppointmentsRepository get appointmentsRepository =>
      AppointmentsRepositoryImpl(appointmentsService);

  @injectable
  MedicalHistoryRepository get medicalHistoryRepository =>
      MedicalHistoryRepositoryImpl(medicalHistoryService);

  // UseCases
  @injectable
  AuthUseCases get authUseCases => AuthUseCases(
        loginUseCase: LoginUseCase(authRepository),
        registerUseCase: RegisterUseCase(authRepository),
        saveUserSessionUseCase: SaveUserSessionUseCase(authRepository),
        getUserSessionUseCase: GetUserSessionUseCase(authRepository),
        logoutUseCase: LogoutUseCase(authRepository),
      );

  @injectable
  UsersUseCases get usersUseCases =>
      UsersUseCases(updateUser: UpdateUserUseCase(usersRepository));

  @injectable
  AmenitiesUseCases get amenitiesUseCases => AmenitiesUseCases(
        getAmenities: GetAmenitiesUseCase(amenitiesRepository),
        deleteAmenities: DeleteAmenitiesUseCase(amenitiesRepository),
        createAmenities: CreateAmenitiesUseCase(amenitiesRepository),
        updateAmenities: UpdateAmenitiesUseCase(amenitiesRepository),
      );

  @injectable
  SpecialtiesUseCases get specialtiesUseCases => SpecialtiesUseCases(
        getSpecialties: GetSpecialtiesUseCase(specialtiesRepository),
      );

  @injectable
  DoctorsUseCases get doctorsUseCases => DoctorsUseCases(
        getDoctors: GetDoctorsUseCase(doctorsRepository),
        getDoctorById: GetDoctorByIdUseCase(doctorsRepository),
        getDoctorSchedules: GetDoctorSchedulesUseCase(doctorsRepository),
        updateDoctorSchedule: UpdateDoctorScheduleUseCase(doctorsRepository),
      );

  @injectable
  AppointmentsUseCases get appointmentsUseCases => AppointmentsUseCases(
        getAppointments: GetAppointmentsUseCase(appointmentsRepository),
        getAvailableSlots: GetAvailableSlotsUseCase(appointmentsRepository),
        createAppointment: CreateAppointmentUseCase(appointmentsRepository),
        cancelAppointment: CancelAppointmentUseCase(appointmentsRepository),
        rescheduleAppointment:
            RescheduleAppointmentUseCase(appointmentsRepository),
        attendAppointment: AttendAppointmentUseCase(appointmentsRepository),
      );

  @injectable
  MedicalHistoryUseCases get medicalHistoryUseCases => MedicalHistoryUseCases(
        getMedicalHistory:
            GetMedicalHistoryUseCase(medicalHistoryRepository),
      );
}