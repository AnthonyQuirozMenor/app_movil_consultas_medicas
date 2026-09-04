import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
const HomeEvent();

  @override
  List<Object?> get props => [];
}

class ChangeDrawerPage extends HomeEvent {
  final int pageIndex;
  const ChangeDrawerPage({required this.pageIndex});

  @override
  List<Object?> get props => [pageIndex];
}

class Logout extends HomeEvent {
  const Logout();
}

class ProfileInfoGetUser extends HomeEvent{
  const ProfileInfoGetUser();
}