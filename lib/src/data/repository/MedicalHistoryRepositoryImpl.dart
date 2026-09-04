import 'package:myfirstlove/src/data/dataSource/remote/service/MedicalHistoryService.dart';
import 'package:myfirstlove/src/domain/models/MedicalHistory.dart';
import 'package:myfirstlove/src/domain/repository/MedicalHistoryRepository.dart';
import 'package:myfirstlove/src/domain/utils/Resource.dart';

class MedicalHistoryRepositoryImpl implements MedicalHistoryRepository {
  final MedicalHistoryService medicalHistoryService;

  MedicalHistoryRepositoryImpl(this.medicalHistoryService);

  @override
  Future<Resource<List<MedicalHistory>>> getHistoryByPatient(String patientId) {
    return medicalHistoryService.getHistoryByPatient(patientId);
  }
}
