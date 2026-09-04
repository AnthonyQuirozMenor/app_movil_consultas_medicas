import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:myfirstlove/src/domain/models/Amenities.dart';
import 'package:myfirstlove/src/domain/utils/Resource.dart';
import 'package:myfirstlove/src/features/utils/BlocFormItem.dart';

class AdminAmenityCreateState extends Equatable {
  final BlocFormItem name;
  final BlocFormItem description;
  final GlobalKey<FormState>? formKey;
  final Resource? response;

  const AdminAmenityCreateState({
   this.name = const BlocFormItem(error: 'Ingresa el nombre'),
   this.description = const BlocFormItem(),
   this.formKey,
   this.response,
  });

  Amenities toAmenity() => Amenities(
    name: name.value,
    description: description.value,
  );

  AdminAmenityCreateState resetForm(){
    return const AdminAmenityCreateState();
  }
   AdminAmenityCreateState copyWith({
    BlocFormItem? name,
    BlocFormItem? description,
    GlobalKey<FormState>? formKey,
    Resource? response,
  }) {
    return AdminAmenityCreateState(
      name: name ?? this.name,
      description: description ?? this.description,
      formKey: formKey, 
      response: response,
    );
  }
@override
  List<Object?> get props => [name, description, response];

}