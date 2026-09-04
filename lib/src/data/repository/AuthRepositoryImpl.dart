import 'package:myfirstlove/src/data/dataSource/local/SharedPref.dart';
import 'package:myfirstlove/src/data/dataSource/remote/service/AuthService.dart';
import 'package:myfirstlove/src/domain/models/AuthResponse.dart';
import 'package:myfirstlove/src/domain/models/User.dart';
import 'package:myfirstlove/src/domain/repository/AuthRepository.dart';
import 'package:myfirstlove/src/domain/utils/Resource.dart';

class AuthRepositoryImpl implements AuthRepository{
  AuthService authService;
  SharedPref sharedPref;
  AuthRepositoryImpl(this.authService, this.sharedPref);
  
  @override
  Future<AuthResponse?> getUserSession() async{
    final data = await sharedPref.read('user');
    if(data !=null){
      AuthResponse authResponse = AuthResponse.fromJson(data);
      return authResponse;
    }
    return null;
  }

  @override
  Future<Resource<AuthResponse>> login(String email, String password) {
   return authService.login(email, password);
  }

  @override
  Future<bool?> logout() async{
    return await sharedPref.remove('user');
  }

  @override
  Future<Resource<AuthResponse>> register(User user) {
   return authService.register(user);
  }

  @override
  Future<void> saveUserSession(AuthResponse authResponse) async {
    sharedPref.save('user', authResponse.toJson());
  }

}