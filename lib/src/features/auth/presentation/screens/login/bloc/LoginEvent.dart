import 'package:equatable/equatable.dart';
import 'package:myfirstlove/src/domain/models/AuthResponse.dart';
import 'package:myfirstlove/src/features/utils/BlocFormItem.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
  @override
  List<Object?> get props => [];
}

class LoginInit extends LoginEvent {
  const LoginInit();
}

class LoginEmailChanged extends LoginEvent {
  final BlocFormItem email;
  const LoginEmailChanged({required this.email});
  @override
  List<Object?> get props => [email];
}

class LoginPasswordChanged extends LoginEvent {
  final BlocFormItem password;
  const LoginPasswordChanged({required this.password});
  @override
  List<Object?> get props => [password];
}

class LoginSubmitted extends LoginEvent {
  const LoginSubmitted();
}
class LoginFormReset extends LoginEvent {
  const LoginFormReset();
}

class LoginSaveUserSession extends LoginEvent{
  final AuthResponse authResponse;
  const LoginSaveUserSession({required this.authResponse});
  @override
  List<Object?> get props => [authResponse];

}

