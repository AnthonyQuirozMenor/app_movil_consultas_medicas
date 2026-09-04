import 'package:myfirstlove/src/domain/repository/AmenitiesRepository.dart';

class DeleteAmenitiesUseCase {
 AmenitiesRepository amenitiesRepository;
  //enviar el repositorio por el constructor
  DeleteAmenitiesUseCase(this.amenitiesRepository);
 
 run (int id)=>amenitiesRepository.delete(id);
 
}