import 'package:myfirstlove/src/domain/models/User.dart';
import 'package:myfirstlove/src/domain/repository/AuthRepository.dart';

class RegisterUseCase {
  AuthRepository authRepository;
  RegisterUseCase(this.authRepository);
  run(User user) => authRepository.register(user);

}