import 'package:myfirstlove/src/domain/models/MedicalHistory.dart';
import 'package:myfirstlove/src/domain/repository/MedicalHistoryRepository.dart';
import 'package:myfirstlove/src/domain/utils/Resource.dart';

class GetMedicalHistoryUseCase {
  final MedicalHistoryRepository repository;

  GetMedicalHistoryUseCase(this.repository);

  Future<Resource<List<MedicalHistory>>> run(String patientId) {
    return repository.getHistoryByPatient(patientId);
  }
}
