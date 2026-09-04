import 'package:myfirstlove/src/domain/repository/AmenitiesRepository.dart';

class GetAmenitiesUseCase {
AmenitiesRepository amenitiesRepository;

GetAmenitiesUseCase(this.amenitiesRepository);

 run() => amenitiesRepository.getAmenities();
}