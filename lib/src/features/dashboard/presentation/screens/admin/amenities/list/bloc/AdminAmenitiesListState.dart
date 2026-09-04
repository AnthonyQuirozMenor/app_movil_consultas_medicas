import 'package:equatable/equatable.dart';
import 'package:myfirstlove/src/domain/utils/Resource.dart';

class AdminAmenitiesListState extends Equatable {
  final Resource? response;

  const AdminAmenitiesListState({this.response});

  AdminAmenitiesListState copyWith({Resource? response}) {
    return AdminAmenitiesListState(response: response);
  }

  @override
  List<Object?> get props => [response];
}