import 'package:myfirstlove/src/domain/models/Amenities.dart';
import 'package:myfirstlove/src/domain/repository/AmenitiesRepository.dart';

class UpdateAmenitiesUseCase {
AmenitiesRepository amenitiesRepository;

UpdateAmenitiesUseCase(this.amenitiesRepository);
run(int id, Amenities amenity)=> amenitiesRepository.update(id, amenity);

}