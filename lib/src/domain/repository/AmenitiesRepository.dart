import 'package:myfirstlove/src/domain/models/Amenities.dart';
import 'package:myfirstlove/src/domain/utils/Resource.dart';

abstract class AmenitiesRepository {

  Future<Resource<Amenities>> create(Amenities amenities);
  Future<Resource<Amenities>> update(int id, Amenities amenities);
  Future<Resource<List<Amenities>>> getAmenities();
  Future<Resource<bool>> delete(int id);
  

}