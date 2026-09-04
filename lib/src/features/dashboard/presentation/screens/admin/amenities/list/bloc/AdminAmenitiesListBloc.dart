import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myfirstlove/src/domain/useCase/Amenities/AmenitiesUseCases.dart';
import 'package:myfirstlove/src/domain/utils/Resource.dart';
import 'package:myfirstlove/src/features/dashboard/presentation/screens/admin/amenities/list/bloc/AdminAmenitiesListEvent.dart';
import 'package:myfirstlove/src/features/dashboard/presentation/screens/admin/amenities/list/bloc/AdminAmenitiesListState.dart';

class AdminAmenitiesListBloc
    extends Bloc<AdminAmenitiesListEvent, AdminAmenitiesListState> {
  
  // La dependencia ahora es AmenitiesUseCases
  AmenitiesUseCases amenitiesUseCases;

  AdminAmenitiesListBloc(this.amenitiesUseCases)
      : super(const AdminAmenitiesListState()) {
    on<GetAmenities>(_onGetAmenities);
    on<DeleteAmenity>(_onDeleteAmenity);
  }

  Future<void> _onGetAmenities(
      GetAmenities event, Emitter<AdminAmenitiesListState> emit) async {
    emit(state.copyWith(response: Loading()));
    // Llama al caso de uso para obtener comodidades
    Resource response = await amenitiesUseCases.getAmenities.run();
    emit(state.copyWith(response: response));
  }

  Future<void> _onDeleteAmenity(
      DeleteAmenity event, Emitter<AdminAmenitiesListState> emit) async {
    emit(state.copyWith(response: Loading()));
    // Llama al caso de uso para eliminar una comodidad
    Resource response = await amenitiesUseCases.deleteAmenities.run(event.id);
    emit(state.copyWith(response: response));
  }
}