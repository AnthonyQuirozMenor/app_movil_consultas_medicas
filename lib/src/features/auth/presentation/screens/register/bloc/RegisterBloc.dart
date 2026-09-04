import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myfirstlove/src/domain/utils/Resource.dart';
import 'package:myfirstlove/src/features/auth/presentation/screens/register/bloc/RegisterEvent.dart';
import 'package:myfirstlove/src/features/auth/presentation/screens/register/bloc/RegisterState.dart';
import 'package:myfirstlove/src/features/utils/BlocFormItem.dart';

class RegisterBloc extends Bloc<RegisterEvent,RegisterState>  {
 RegisterBloc():super(RegisterState(formKey: GlobalKey<FormState>(),response: Initial())) {

  on<RegisterInit>(_onInit);
  on<RegisterNameChanged>(_onNameChanged);
  on<RegisterLastNameChanged>(_onLastNameChanged);
  on<RegisterEmailChanged>(_onEmailChanged);
  on<RegisterPasswordChanged>(_onPasswordChanged);
  on<RegisterConfirmPasswordChanged>(_onConfirmPasswordChanged);
  on<RegisterSubmitted>(_onSubmitted);
 }
  final formKey = GlobalKey<FormState>();
  void _onInit(RegisterInit event, Emitter<RegisterState> emit) {
    emit(RegisterState(formKey: formKey, response: Initial()));
    
  }
  Future<void> _onNameChanged(RegisterNameChanged event, Emitter<RegisterState> emit) async {
    emit(state.copyWith(
      name: BlocFormItem(
        value: event.name.value,
        error: event.name.value.isNotEmpty ? null : 'Ingresa tu nombre',
      ),
      formKey: formKey,
    ));
  }
  Future<void> _onLastNameChanged(RegisterLastNameChanged event, Emitter<RegisterState> emit) async {
    emit(state.copyWith(
      lastname: BlocFormItem(
        value: event.lastname.value,
        error: event.lastname.value.isNotEmpty ? null : 'Ingresa tu apellido',
      ),
      formKey: formKey,
    ));
  }
  Future<void> _onEmailChanged(RegisterEmailChanged event, Emitter<RegisterState> emit) async {
    emit(state.copyWith(
      email: BlocFormItem(
        value: event.email.value,
        error: event.email.value.isNotEmpty ? null : 'Ingresa tu correo',
      ),
      formKey: formKey,
    ));
  }
  Future<void> _onPasswordChanged(RegisterPasswordChanged event, Emitter<RegisterState> emit) async {
    emit(state.copyWith(
      password: BlocFormItem(
        value: event.password.value,
        error: event.password.value.isNotEmpty ? null : 'Ingresa tu contraseña',
      ),
      formKey: formKey,
    ));
  }
  Future<void> _onConfirmPasswordChanged(RegisterConfirmPasswordChanged event, Emitter<RegisterState> emit) async {
    emit(state.copyWith(
      confirmPassword: BlocFormItem(
        value: event.confirmPassword.value,
        error: event.confirmPassword.value.isNotEmpty ? null : 'Confirma tu contraseña',
      ),
      formKey: formKey,
    ));
  }
  Future<void> _onSubmitted(RegisterSubmitted event, Emitter<RegisterState> emit) async {
    final name = state.name.value.trim();
    final lastName = state.lastname.value.trim();
    final email = state.email.value.trim();
    final password = state.password.value.trim();
    final confirmPassword = state.confirmPassword.value.trim();
    final nameError = name.isEmpty ? 'Ingresa tu nombre' : null;
    final lastNameError = lastName.isEmpty ? 'Ingresa tu apellido' : null;
    final emailError = email.isEmpty ? 'Ingresa el email' : null;
    final passwordError = password.length < 6 ? 'Password mínimo 6 caracteres' : null;
    final confirmPasswordError = confirmPassword != password ? 'Las contraseñas no coinciden' : null;

    emit(state.copyWith(
      name: state.name.copyWith(error: nameError),
      lastname: state.lastname.copyWith(error: lastNameError),
      email: state.email.copyWith(error: emailError),
      password: state.password.copyWith(error: passwordError),
      confirmPassword: state.confirmPassword.copyWith(error: confirmPasswordError),
    ));

    if (nameError != null || lastNameError != null || emailError != null || passwordError != null || confirmPasswordError != null) {
      return;
    }

    emit(state.copyWith(response: Loading()));
    await Future.delayed(const Duration(seconds: 6));

    // Simulación de registro exitoso
    emit(state.copyWith(response: Success("Usuario registrado con éxito")));
  }


  
}