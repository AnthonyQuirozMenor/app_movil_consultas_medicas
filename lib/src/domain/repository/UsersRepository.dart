import 'dart:io';

import 'package:myfirstlove/src/domain/models/User.dart';
import 'package:myfirstlove/src/domain/utils/Resource.dart';

abstract class UsersRepository {
  Future<Resource<User>> update(int id, User user, File? image);
}