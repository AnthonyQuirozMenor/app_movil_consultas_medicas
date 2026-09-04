import 'package:myfirstlove/src/domain/repository/AuthRepository.dart';

class LoginUseCase {

AuthRepository authRepository;
LoginUseCase(this.authRepository);

run(String email,String password)=>authRepository.login(email, password);

}