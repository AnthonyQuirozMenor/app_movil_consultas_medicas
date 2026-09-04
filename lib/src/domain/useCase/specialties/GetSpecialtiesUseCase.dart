import 'package:myfirstlove/src/domain/models/Specialty.dart';
import 'package:myfirstlove/src/domain/repository/SpecialtiesRepository.dart';
import 'package:myfirstlove/src/domain/utils/Resource.dart';

class GetSpecialtiesUseCase {
  final SpecialtiesRepository repository;

  GetSpecialtiesUseCase(this.repository);

  Future<Resource<List<Specialty>>> run() {
    return repository.getSpecialties();
  }
}
