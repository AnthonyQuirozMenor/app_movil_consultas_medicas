// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:myfirstlove/src/data/dataSource/local/SharedPref.dart' as _i920;
import 'package:myfirstlove/src/data/dataSource/remote/service/AmenitiesService.dart'
    as _i217;
import 'package:myfirstlove/src/data/dataSource/remote/service/AppointmentsService.dart'
    as _i801;
import 'package:myfirstlove/src/data/dataSource/remote/service/AuthService.dart'
    as _i45;
import 'package:myfirstlove/src/data/dataSource/remote/service/DoctorsService.dart'
    as _i802;
import 'package:myfirstlove/src/data/dataSource/remote/service/MedicalHistoryService.dart'
    as _i803;
import 'package:myfirstlove/src/data/dataSource/remote/service/SpecialtiesService.dart'
    as _i804;
import 'package:myfirstlove/src/data/dataSource/remote/service/UsersService.dart'
    as _i1043;
import 'package:myfirstlove/src/di/AppModule.dart' as _i691;
import 'package:myfirstlove/src/domain/repository/AmenitiesRepository.dart'
    as _i589;
import 'package:myfirstlove/src/domain/repository/AppointmentsRepository.dart'
    as _i805;
import 'package:myfirstlove/src/domain/repository/AuthRepository.dart' as _i496;
import 'package:myfirstlove/src/domain/repository/DoctorsRepository.dart'
    as _i806;
import 'package:myfirstlove/src/domain/repository/MedicalHistoryRepository.dart'
    as _i807;
import 'package:myfirstlove/src/domain/repository/SpecialtiesRepository.dart'
    as _i808;
import 'package:myfirstlove/src/domain/repository/UsersRepository.dart'
    as _i285;
import 'package:myfirstlove/src/domain/useCase/Amenities/AmenitiesUseCases.dart'
    as _i292;
import 'package:myfirstlove/src/domain/useCase/appointments/AppointmentsUseCases.dart'
    as _i809;
import 'package:myfirstlove/src/domain/useCase/Auth/AuthUseCases.dart' as _i584;
import 'package:myfirstlove/src/domain/useCase/doctors/DoctorsUseCases.dart'
    as _i810;
import 'package:myfirstlove/src/domain/useCase/medicalHistory/MedicalHistoryUseCases.dart'
    as _i811;
import 'package:myfirstlove/src/domain/useCase/specialties/SpecialtiesUseCases.dart'
    as _i812;
import 'package:myfirstlove/src/domain/useCase/users/UsersUseCases.dart'
    as _i279;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final appModule = _$AppModule();
    gh.factory<_i920.SharedPref>(() => appModule.sharedPref);
    gh.factoryAsync<String>(() => appModule.token);
    gh.factory<_i45.AuthService>(() => appModule.authService);
    gh.factory<_i1043.UsersService>(() => appModule.usersService);
    gh.factory<_i217.AmenitiesService>(() => appModule.amenitiesService);
    gh.factory<_i804.SpecialtiesService>(() => appModule.specialtiesService);
    gh.factory<_i802.DoctorsService>(() => appModule.doctorsService);
    gh.factory<_i801.AppointmentsService>(() => appModule.appointmentsService);
    gh.factory<_i803.MedicalHistoryService>(
        () => appModule.medicalHistoryService);

    gh.factory<_i496.AuthRepository>(() => appModule.authRepository);
    gh.factory<_i285.UsersRepository>(() => appModule.usersRepository);
    gh.factory<_i589.AmenitiesRepository>(() => appModule.amenitiesRepository);
    gh.factory<_i808.SpecialtiesRepository>(
        () => appModule.specialtiesRepository);
    gh.factory<_i806.DoctorsRepository>(() => appModule.doctorsRepository);
    gh.factory<_i805.AppointmentsRepository>(
        () => appModule.appointmentsRepository);
    gh.factory<_i807.MedicalHistoryRepository>(
        () => appModule.medicalHistoryRepository);

    gh.factory<_i584.AuthUseCases>(() => appModule.authUseCases);
    gh.factory<_i279.UsersUseCases>(() => appModule.usersUseCases);
    gh.factory<_i292.AmenitiesUseCases>(() => appModule.amenitiesUseCases);
    gh.factory<_i812.SpecialtiesUseCases>(() => appModule.specialtiesUseCases);
    gh.factory<_i810.DoctorsUseCases>(() => appModule.doctorsUseCases);
    gh.factory<_i809.AppointmentsUseCases>(
        () => appModule.appointmentsUseCases);
    gh.factory<_i811.MedicalHistoryUseCases>(
        () => appModule.medicalHistoryUseCases);

    return this;
  }
}

class _$AppModule extends _i691.AppModule {}
