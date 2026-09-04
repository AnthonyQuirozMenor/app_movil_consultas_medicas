import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:myfirstlove/src/domain/utils/Resource.dart';
import 'package:myfirstlove/src/features/utils/BlocFormItem.dart';

class RegisterState extends Equatable {
final BlocFormItem name;
final  BlocFormItem lastname;
final  BlocFormItem email;
final  BlocFormItem password;
final  BlocFormItem confirmPassword;
final Resource? response;
final GlobalKey<FormState>? formKey;

const RegisterState(
  {
    this.name = const BlocFormItem(error: 'Ingresa el nombre'),
    this.lastname = const BlocFormItem(error: 'Ingresa el apellido'),
    this.email = const BlocFormItem(error: 'Ingresa el email'),
    this.password = const BlocFormItem(error: 'Ingresa el password'),
    this.confirmPassword = const BlocFormItem(error: 'Confirma el password'),
    this.formKey,
    this.response 
    });
  RegisterState copyWith({ BlocFormItem? name,
                              BlocFormItem? lastname,
                              BlocFormItem? email,
                              BlocFormItem? password,
                              BlocFormItem? confirmPassword,
                              Resource? response, 
                              GlobalKey<FormState>? formKey
  }){
    return RegisterState(
                      name: name?? this.name,
                      lastname: lastname?? this.lastname,
                      email: email?? this.email,
                      password: password?? this.password,
                      confirmPassword: confirmPassword?? this.confirmPassword,
                      formKey: formKey,
                      response: response);
  }
  
  @override
  List<Object?> get props => [name,lastname,email,password,confirmPassword,response];



}