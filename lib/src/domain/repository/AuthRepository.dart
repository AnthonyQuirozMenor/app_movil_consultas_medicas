import 'package:myfirstlove/src/domain/models/AuthResponse.dart';
import 'package:myfirstlove/src/domain/models/User.dart';
import 'package:myfirstlove/src/domain/utils/Resource.dart';

abstract class AuthRepository {
  Future<Resource<AuthResponse>>login(String email, String password);
  Future<Resource<AuthResponse>> register(User user);
  Future<bool?> logout();
  Future<void>saveUserSession(AuthResponse authResponse);
  Future<AuthResponse?> getUserSession();

}