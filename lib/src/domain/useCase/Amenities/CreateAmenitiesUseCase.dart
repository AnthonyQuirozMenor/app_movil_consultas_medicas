import 'package:myfirstlove/src/domain/models/Amenities.dart';
import 'package:myfirstlove/src/domain/repository/AmenitiesRepository.dart';

class CreateAmenitiesUseCase {
AmenitiesRepository amenitiesRepository;
CreateAmenitiesUseCase(this.amenitiesRepository);

run(Amenities amenity)=> amenitiesRepository.create(amenity);

}