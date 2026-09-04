import 'dart:io';

import 'package:myfirstlove/src/data/dataSource/remote/service/UsersService.dart';
import 'package:myfirstlove/src/domain/models/User.dart';
import 'package:myfirstlove/src/domain/repository/UsersRepository.dart';
import 'package:myfirstlove/src/domain/utils/Resource.dart';

class UsersRepositoryImpl implements UsersRepository{
    UsersService usersService;
  UsersRepositoryImpl(this.usersService);

  @override
  Future<Resource<User>> update(int id, User user, File? image) {
   if (image == null) {
      return usersService.update(id, user);
    } else {
      return usersService.updateImage(id, user, image);
    }
  }

}