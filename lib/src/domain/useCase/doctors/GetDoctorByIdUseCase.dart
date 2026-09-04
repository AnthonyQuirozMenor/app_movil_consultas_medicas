import 'package:myfirstlove/src/domain/models/Doctor.dart';
import 'package:myfirstlove/src/domain/repository/DoctorsRepository.dart';
import 'package:myfirstlove/src/domain/utils/Resource.dart';

class GetDoctorByIdUseCase {
  final DoctorsRepository repository;

  GetDoctorByIdUseCase(this.repository);

  Future<Resource<Doctor>> run(String id) {
    return repository.getDoctorById(id);
  }
}
