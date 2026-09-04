import 'package:equatable/equatable.dart';
import 'package:myfirstlove/src/features/utils/BlocFormItem.dart';

abstract class AdminAmenityCreateEvent extends Equatable {
const AdminAmenityCreateEvent();
 @override
  List<Object?> get props => [];
}

class AdminAmenityCreateInitEvent extends AdminAmenityCreateEvent {
  const AdminAmenityCreateInitEvent();
}
class NameChanged extends AdminAmenityCreateEvent {
  final BlocFormItem name;
  const NameChanged({required this.name});
  @override
  List<Object?> get props => [name];
}

class DescriptionChanged extends AdminAmenityCreateEvent {
  final BlocFormItem description;
  const DescriptionChanged({required this.description});
  @override
  List<Object?> get props => [description];
}

class FormSubmit extends AdminAmenityCreateEvent {
  const FormSubmit();
}

class ResetForm extends AdminAmenityCreateEvent {
  const ResetForm();
}



