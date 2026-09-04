import 'package:myfirstlove/src/domain/useCase/Amenities/CreateAmenitiesUseCase.dart';
import 'package:myfirstlove/src/domain/useCase/Amenities/DeleteAmenitiesUseCase.dart';
import 'package:myfirstlove/src/domain/useCase/Amenities/GetAmenitiesUseCase.dart';
import 'package:myfirstlove/src/domain/useCase/Amenities/UpdateAmenitiesUseCase.dart';

class AmenitiesUseCases {
  GetAmenitiesUseCase getAmenities;
  DeleteAmenitiesUseCase deleteAmenities;
  CreateAmenitiesUseCase createAmenities;
  UpdateAmenitiesUseCase updateAmenities;

  AmenitiesUseCases(
    {
      required this.getAmenities,
      required this.deleteAmenities,
      required this.createAmenities,
      required this.updateAmenities
      }
    );

}