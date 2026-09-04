import 'package:myfirstlove/src/domain/models/MedicalHistory.dart';
import 'package:myfirstlove/src/domain/utils/Resource.dart';

abstract class MedicalHistoryRepository {
  Future<Resource<List<MedicalHistory>>> getHistoryByPatient(String patientId);
}
