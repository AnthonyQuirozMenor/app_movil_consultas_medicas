
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myfirstlove/src/domain/models/AuthResponse.dart';
import 'package:myfirstlove/src/domain/useCase/Auth/AuthUseCases.dart';
import 'package:myfirstlove/src/domain/utils/Resource.dart';
import 'package:myfirstlove/src/features/auth/presentation/screens/login/bloc/LoginEvent.dart';
import 'package:myfirstlove/src/features/auth/presentation/screens/login/bloc/LoginState.dart';
import 'package:myfirstlove/src/features/utils/BlocFormItem.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
AuthUseCases authUseCases;


  LoginBloc(this.authUseCases) : super(LoginState()) {
    on<LoginInit>(_onInit);
    on<LoginEmailChanged>(_onEmailChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginSubmitted>(_onSubmitted);

    on<LoginFormReset>(_onLoginFormReset);
    on<LoginSaveUserSession>(_onSaveUserSession);
  }
  final formKey = GlobalKey<FormState>();

  void _onInit(LoginInit event, Emitter<LoginState> emit) async {
   AuthResponse? authResponse = await authUseCases.getUserSessionUseCase.run();
   emit(state.copyWith(formKey:formKey));
   print('Usuario en sesion: ${authResponse?.toJson()}');
   if (authResponse != null) {
      emit(state.copyWith(response: Success(authResponse),//user y el token
       formKey: formKey));
   }

  }

 Future<void> _onEmailChanged(
      LoginEmailChanged event, Emitter<LoginState> emit) async {
    emit(state.copyWith(
        email: BlocFormItem(
            value: event.email.value,
            error: event.email.value.isNotEmpty ? null : 'Ingresa el email'),
        formKey: formKey));
  }

  Future<void> _onPasswordChanged(
      LoginPasswordChanged event, Emitter<LoginState> emit) async {
    emit(state.copyWith(
        password: BlocFormItem(
            value: event.password.value,
            error: event.password.value.isNotEmpty &&
                    event.password.value.length >= 6
                ? null
                : 'Ingresa el password'),
        formKey: formKey));
  }

  Future<void> _onSubmitted(LoginSubmitted event, Emitter<LoginState> emit) async {
    emit(
      state.copyWith(response: Loading(), formKey: formKey),
    );
    await Future.delayed(const Duration(seconds: 6));
    Resource resource= 
    await authUseCases.loginUseCase.run(state.email.value, state.password.value);
    emit(state.copyWith(response: resource, formKey: formKey));
  }

  Future<void> _onLoginFormReset( LoginFormReset event, Emitter<LoginState> emit) async {
       state.formKey?.currentState?.reset();
  }

  Future<void> _onSaveUserSession(LoginSaveUserSession event, Emitter<LoginState> emit) async {
    await authUseCases.saveUserSessionUseCase.run(event.authResponse);
  }

}
