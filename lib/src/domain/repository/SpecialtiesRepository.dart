import 'package:myfirstlove/src/domain/models/Specialty.dart';
import 'package:myfirstlove/src/domain/utils/Resource.dart';

abstract class SpecialtiesRepository {
  Future<Resource<List<Specialty>>> getSpecialties();
}
