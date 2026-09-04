import 'package:myfirstlove/src/data/dataSource/remote/service/SpecialtiesService.dart';
import 'package:myfirstlove/src/domain/models/Specialty.dart';
import 'package:myfirstlove/src/domain/repository/SpecialtiesRepository.dart';
import 'package:myfirstlove/src/domain/utils/Resource.dart';

class SpecialtiesRepositoryImpl implements SpecialtiesRepository {
  final SpecialtiesService specialtiesService;

  SpecialtiesRepositoryImpl(this.specialtiesService);

  @override
  Future<Resource<List<Specialty>>> getSpecialties() {
    return specialtiesService.getSpecialties();
  }
}
