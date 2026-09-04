import 'package:equatable/equatable.dart';

abstract class HomeClientEvent extends Equatable {
const HomeClientEvent();

  @override
  List<Object?> get props => [];
}

class ChangeDrawerPage extends HomeClientEvent {
  final int pageIndex;
  const ChangeDrawerPage({required this.pageIndex});

  @override
  List<Object?> get props => [pageIndex];
}

class Logout extends HomeClientEvent {
  const Logout();
}

class ProfileInfoGetUser extends HomeClientEvent {
  const ProfileInfoGetUser();
}