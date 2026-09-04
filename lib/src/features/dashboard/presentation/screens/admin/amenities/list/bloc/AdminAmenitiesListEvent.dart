import 'package:equatable/equatable.dart';

abstract class AdminAmenitiesListEvent extends Equatable {
  const AdminAmenitiesListEvent();
  @override
  List<Object?> get props => [];
}

// Evento para obtener la lista de comodidades
class GetAmenities extends AdminAmenitiesListEvent {
  const GetAmenities();
}

// Evento para eliminar una comodidad por su ID
class DeleteAmenity extends AdminAmenitiesListEvent {
  final int id;
  const DeleteAmenity({required this.id});
  @override
  List<Object?> get props => [id];
}