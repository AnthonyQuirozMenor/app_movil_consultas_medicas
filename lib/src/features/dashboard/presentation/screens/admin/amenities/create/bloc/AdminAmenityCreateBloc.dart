import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myfirstlove/src/domain/useCase/Amenities/AmenitiesUseCases.dart';
import 'package:myfirstlove/src/domain/utils/Resource.dart';
import 'package:myfirstlove/src/features/dashboard/presentation/screens/admin/amenities/create/bloc/AdminAmenityCreateEvent.dart';
import 'package:myfirstlove/src/features/dashboard/presentation/screens/admin/amenities/create/bloc/AdminAmenityCreateState.dart';
import 'package:myfirstlove/src/features/utils/BlocFormItem.dart';

class AdminAmenityCreateBloc extends Bloc<AdminAmenityCreateEvent,AdminAmenityCreateState > {
  AmenitiesUseCases amenitiesUseCases;

  
 AdminAmenityCreateBloc(this.amenitiesUseCases): super 
 (const AdminAmenityCreateState()){
   on<AdminAmenityCreateInitEvent>(_onInitEvent);
    on<NameChanged>(_onNameChanged);
    on<DescriptionChanged>(_onDescriptionChanged);
    on<FormSubmit>(_onFormSubmit);
    on<ResetForm>(_onResetForm);
 }
 final formKey = GlobalKey<FormState>();

   Future<void> _onInitEvent(AdminAmenityCreateInitEvent event,
      Emitter<AdminAmenityCreateState> emit) async {
    emit(state.copyWith(formKey: formKey));
  }
    Future<void> _onNameChanged(
      NameChanged event, Emitter<AdminAmenityCreateState> emit) async {
    emit(state.copyWith(
      name: BlocFormItem(
        value: event.name.value,
        error: event.name.value.isNotEmpty ? null : 'Ingresa el nombre',
      ),
      formKey: formKey,
    ));
  }
   Future<void> _onDescriptionChanged(
      DescriptionChanged event, Emitter<AdminAmenityCreateState> emit) async {
    emit(state.copyWith(
      description: BlocFormItem(value: event.description.value),
      formKey: formKey,
    ));
  }
    Future<void> _onFormSubmit(
      FormSubmit event, Emitter<AdminAmenityCreateState> emit) async {
    emit(state.copyWith(response: Loading(), formKey: formKey));
    Resource response = await amenitiesUseCases.createAmenities.run(state.toAmenity());
    emit(state.copyWith(response: response, formKey: formKey));
  }

   Future<void> _onResetForm(
      ResetForm event, Emitter<AdminAmenityCreateState> emit) async {
    emit(state.resetForm());
  }

}