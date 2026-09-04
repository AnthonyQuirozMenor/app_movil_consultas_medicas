import 'package:equatable/equatable.dart';
import 'package:myfirstlove/src/domain/models/User.dart';

class HomeClientState extends Equatable {
  final int pageIndex;
  final User? user;

  const HomeClientState({this.pageIndex = 0, this.user});

  HomeClientState copyWith({int? pageIndex, User? user}) {
    return HomeClientState(
      pageIndex: pageIndex ?? this.pageIndex,
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props => [pageIndex, user];
}