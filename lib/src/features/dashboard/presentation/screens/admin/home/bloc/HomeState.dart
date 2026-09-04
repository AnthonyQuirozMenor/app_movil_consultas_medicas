import 'package:equatable/equatable.dart';
import 'package:myfirstlove/src/domain/models/User.dart';

class HomeState extends Equatable {
final int pageIndex;
final User? user;
const HomeState({this.pageIndex = 0, this.user});

  HomeState copyWith({int? pageIndex, User? user}) {
    return HomeState(
      pageIndex: pageIndex ?? this.pageIndex,
      user: user,
    );
  }
  @override
  List<Object?> get props => [pageIndex, user];

}