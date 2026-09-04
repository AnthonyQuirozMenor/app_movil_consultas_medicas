import 'package:myfirstlove/src/domain/useCase/Auth/GetUserSessionUseCase.dart';
import 'package:myfirstlove/src/domain/useCase/Auth/LoginUseCase.dart';
import 'package:myfirstlove/src/domain/useCase/Auth/LogoutUseCase.dart';
import 'package:myfirstlove/src/domain/useCase/Auth/RegisterUseCase.dart';
import 'package:myfirstlove/src/domain/useCase/Auth/SaveUserSessionUseCase.dart';

class AuthUseCases {
  LoginUseCase loginUseCase;
  RegisterUseCase registerUseCase;
  SaveUserSessionUseCase saveUserSessionUseCase;
  GetUserSessionUseCase getUserSessionUseCase;
  LogoutUseCase logoutUseCase;

  AuthUseCases({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.saveUserSessionUseCase,
    required this.getUserSessionUseCase,
    required this.logoutUseCase
  });


}