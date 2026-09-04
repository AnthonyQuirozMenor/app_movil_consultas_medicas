import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myfirstlove/src/domain/models/AuthResponse.dart';
import 'package:myfirstlove/src/domain/useCase/Auth/AuthUseCases.dart';
import 'package:myfirstlove/src/features/dashboard/presentation/screens/client/home/bloc/HomeClientEvent.dart';
import 'package:myfirstlove/src/features/dashboard/presentation/screens/client/home/bloc/HomeClientState.dart';

class HomeClientBloc extends Bloc<HomeClientEvent, HomeClientState> {
  final AuthUseCases authUseCases;

  HomeClientBloc(this.authUseCases) : super(const HomeClientState()) {
    on<Logout>(_onLogout);
    on<ChangeDrawerPage>(_onChangeDrawerPage);
    on<ProfileInfoGetUser>(_onGetUser);
  }

  Future<void> _onLogout(Logout event, Emitter<HomeClientState> emit) async {
    await authUseCases.logoutUseCase.run();
  }

  Future<void> _onChangeDrawerPage(
      ChangeDrawerPage event, Emitter<HomeClientState> emit) async {
    emit(state.copyWith(pageIndex: event.pageIndex));
  }

  Future<void> _onGetUser(
      ProfileInfoGetUser event, Emitter<HomeClientState> emit) async {
    final AuthResponse? authResponse =
        await authUseCases.getUserSessionUseCase.run();
    if (authResponse != null) {
      emit(state.copyWith(user: authResponse.user));
    }
  }
}