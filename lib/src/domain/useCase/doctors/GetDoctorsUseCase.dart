import 'package:myfirstlove/src/domain/models/Doctor.dart';
import 'package:myfirstlove/src/domain/repository/DoctorsRepository.dart';
import 'package:myfirstlove/src/domain/utils/Resource.dart';

class GetDoctorsUseCase {
  final DoctorsRepository repository;

  GetDoctorsUseCase(this.repository);

  Future<Resource<List<Doctor>>> run({String? specialtyId}) {
    return repository.getDoctors(specialtyId: specialtyId);
  }
}
